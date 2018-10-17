# frozen_string_literal: true

class TubemogulApi::Connection
  TUBEMOGUL_API_URL = 'https://api.tubemogul.com'

  attr_reader :config

  def initialize(config = {})
    @config = config
  end

  def connection
    @connection ||= Faraday.new(url) do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.use TubemogulApi::Faraday::Response::RaiseHttpError
      conn.adapter Faraday.default_adapter
      conn.authorization 'Bearer', token
    end
  end

  def token
    @token ||= get_authorization_token
  end

  def get_authorization_token
    connection = Faraday.new(url) do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.use TubemogulApi::Faraday::Response::RaiseHttpError
      conn.adapter Faraday.default_adapter
      conn.basic_auth client_id, secret_key
      conn.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      conn.headers['Cache-Control'] = 'no-cache'
    end

    response = connection.run_request(
      :post,
      'oauth/token',
      'grant_type=client_credentials',
      nil
    )

    response.body['token']
  end

  def url
    config.fetch(:url, TUBEMOGUL_API_URL)
  end

  def client_id
    config.fetch(:client_id, ENV['TUBEMOGUL_CLIENT_ID'])
  end

  def secret_key
    config.fetch(:secret_key, ENV['TUBEMOGUL_SECRET_KEY'])
  end

  def get(uri_suffix, params = {})
    connection.get(uri_suffix, params)
  end

  def post(uri_suffix, params = {})
    connection.post(uri_suffix, params)
  end
end
