# frozen_string_literal: true

VCR.configure do |c|
  c.configure_rspec_metadata!

  c.cassette_library_dir = TubemogulApi.root.join('spec', 'fixtures', 'vcr')
  c.hook_into :webmock

  c.default_cassette_options = { allow_unused_http_interactions: false }

  c.before_record do |i|
    i.request.headers['Authorization'].map! { 'clipped' }
    i.response.headers.delete('Set-Cookie')
  end

  c.filter_sensitive_data('tubemogul-client-id') { ENV.fetch('TUBEMOGUL_CLIENT_ID') }
  c.filter_sensitive_data('tubemogul-secret-key') { ENV.fetch('TUBEMOGUL_SECRET_KEY') }
  c.filter_sensitive_data('123456') { ENV.fetch('ACCOUNT_ID') }

  # filter other sensitive data from response
  c.before_record do |interaction|
    response = JSON.parse(interaction.response.body)

    interaction.filter!(response['token'], 'some-token')
  end
end
