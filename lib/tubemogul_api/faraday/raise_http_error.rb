# frozen_string_literal: true

module TubemogulApi
  module Faraday
    module Response
      class RaiseHttpError < ::Faraday::Response::Middleware
        EXCEPTIONS = {
          400 => TubemogulApi::BadRequest,
          401 => TubemogulApi::Unauthorized,
          403 => TubemogulApi::Forbidden,
          404 => TubemogulApi::NotFound,
          406 => TubemogulApi::NotAcceptable,
          422 => TubemogulApi::UnprocessableEntity,
          500 => TubemogulApi::InternalServerError,
          501 => TubemogulApi::NotImplemented,
          502 => TubemogulApi::BadGateway,
          503 => TubemogulApi::ServiceUnavailable
        }.freeze

        def on_complete(response)
          http_status = response.status.to_i

          return if http_status == 200

          exception = EXCEPTIONS.fetch(http_status)

          raise exception, response.body
        end

        def error_message(response)
          "#{response.method.to_s.upcase} #{response.url}: #{response.status} - #{response.body}"
        end
      end
    end
  end
end
