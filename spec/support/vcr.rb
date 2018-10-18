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
  c.filter_sensitive_data('sample-advertiser-id') { ENV.fetch('SAMPLE_ADVERTISER_ID') }

  FAKE_ACCOUNT_ID = '12345'.freeze

  # filter other sensitive data from response
  c.before_record do |interaction|
    response = JSON.parse(interaction.response.body)

    interaction.filter!(response['account_id'], FAKE_ACCOUNT_ID)
    interaction.filter!(response['token'], 'some-token')
  end

  anonymize_advertiser = lambda do |advertiser, id|
    advertiser.each_key do |key|
      case key
      when 'advertiser_id'
        advertiser[key] = id
      when '@uri'
        advertiser[key] = advertiser[key].sub(%r{(trafficking\/advertisers\/)([^\?]+)}, "\\1#{id}")
      when 'advertiser_name'
        advertiser[key] = "Advertiser #{id}"
      when 'advertiser_domain'
        advertiser[key] = "https://#{id}.example.com"
      when 'account_id'
        advertiser[key] = FAKE_ACCOUNT_ID
      end
    end
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~ %r{trafficking\/advertisers\/sample-advertiser-id(\?.*)?}

    response = JSON.parse(interaction.response.body)
    anonymize_advertiser.call(response, 'sample-advertiser-id')

    interaction.response.body = response.to_json
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~ %r{trafficking\/advertisers(\?.*)?}

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']
    items.each_with_index do |item, index|
      anonymize_advertiser.call(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end
end
