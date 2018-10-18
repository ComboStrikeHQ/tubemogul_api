# frozen_string_literal: true

class TubemogulApi::Connection
  TUBEMOGUL_API_URL = 'https://api.tubemogul.com'.freeze

  attr_reader :config

  def initialize(config = {})
    @config = config
  end

  def connection
    @connection ||= connection_builder do |conn|
      conn.authorization 'Bearer', token
    end
  end

  def get(uri_suffix, params = {})
    connection.get(uri_suffix, params)
  end

  def post(uri_suffix, params = {})
    connection.post(uri_suffix, params)
  end

  private

  def url
    config.fetch(:url, TUBEMOGUL_API_URL)
  end

  def client_id
    config.fetch(:client_id, ENV['TUBEMOGUL_CLIENT_ID'])
  end

  def secret_key
    config.fetch(:secret_key, ENV['TUBEMOGUL_SECRET_KEY'])
  end

  def token
    @token ||= fetch_authorization_token
  end

  def fetch_authorization_token
    connection = connection_builder do |conn|
      conn.basic_auth client_id, secret_key
      conn.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      conn.headers['Cache-Control'] = 'no-cache'
    end

    response = connection.run_request(:post, 'oauth/token', 'grant_type=client_credentials', nil)

    response.body['token']
  end

  def connection_builder
    Faraday.new(url) do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.use TubemogulApi::Faraday::Response::RaiseHttpError
      conn.adapter Faraday.default_adapter
      yield conn
    end
  end
end
