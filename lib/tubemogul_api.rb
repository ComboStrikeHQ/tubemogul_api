# frozen_string_literal: true

require 'faraday_middleware'

require 'tubemogul_api/error'
require 'tubemogul_api/faraday/raise_http_error'

require 'tubemogul_api/connection'
require 'tubemogul_api/service'
require 'tubemogul_api/resource'
require 'tubemogul_api/version'

module TubemogulApi
  AUTOLOAD_PATHS = [
    Dir[File.dirname(__dir__) + '/lib/tubemogul_api/resource/*.rb'],
    Dir[File.dirname(__dir__) + '/lib/tubemogul_api/service/*.rb']
  ].flatten.freeze

  def self.root
    Pathname.new(File.dirname(__dir__))
  end

  AUTOLOAD_PATHS.each { |file| require file }
end
