# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-advertiser-id') { ENV.fetch('SAMPLE_ADVERTISER_ID') }

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
      end
    end
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~
        %r{trafficking\/advertisers\/sample-advertiser-id(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    anonymize_advertiser.call(response, 'sample-advertiser-id')

    interaction.response.body = response.to_json
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~ %r{trafficking\/advertisers(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']
    items.each_with_index do |item, index|
      anonymize_advertiser.call(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end
end
