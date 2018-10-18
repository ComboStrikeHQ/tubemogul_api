# frozen_string_literal: true

require 'yaml'

class TubemogulApi::Service
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
    @@endpoints ||= YAML.load_file(
      TubemogulApi.root.join('lib', 'config', 'endpoints_for_services.yaml')
    )

    endpoint = @@endpoints['service'][name]

    endpoint || raise(TubemogulApi::NotImplemented, "No endpoint for service #{name} available.")
  end

  def get(id, params = {})
    response = @connection.get("#{uri_suffix}/#{id}", params).body

    parse_response(response)
  end

  def get_all(params = {})
    response = @connection.get(uri_suffix, params).body

    parse_response(response)
  end

  def parse_response(response)
    case response['@type']
    when 'Collection'
      response['items'].map do |json|
        parse_response(json)
      end
    when 'Advertiser'
      TubemogulApi::Resource::Advertiser.new(response, self)
    else
      raise(TubemogulApi::NotImplemented, format('Unknown response type %s.', response['@type']))
    end
  end
end
