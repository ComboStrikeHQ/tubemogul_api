# frozen_string_literal: true

require 'yaml'
require 'ostruct'

class TubemogulApi::Service
  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def name
    @name ||= begin
      str = self.class.name.split('::').last
      str.gsub(/(.)([A-Z])/, '\1_\2').downcase
    end
  end

  def uri_suffix
    @@endpoints ||= YAML.load_file( # rubocop:disable Style/ClassVars
      TubemogulApi.root.join('lib', 'config', 'endpoints_for_services.yaml')
    )

    endpoint = @@endpoints['service'][name]

    endpoint || raise(TubemogulApi::NotImplemented, "No endpoint for service #{name} available.")
  end

  def get(id, params = {})
    response = connection.get("#{uri_suffix}/#{id}", params).body

    parse_response(response)
  end

  def get_all(params = {})
    response = connection.get(uri_suffix, params).body

    parse_response(response)
  end

  def parse_response(response)
    case response['@type']
    when 'Collection'
      parse_collection(response)
    when 'Advertiser'
      OpenStruct.new(response)
    else
      raise(TubemogulApi::NotImplemented, format('Unknown response type %s.', response['@type']))
    end
  end

  def parse_collection(response)
    Enumerator.new do |y|
      loop do
        response['items'].each do |json|
          y << parse_response(json)
        end
        paging = response['paging']
        break unless paging['has_more_items']
        response = connection.get(paging['next_page_uri']).body
      end
    end
  end
end
