# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-campaign-id') { ENV.fetch('SAMPLE_CAMPAIGN_ID') }

  anonymize_campaign = lambda do |campaign, id|
    campaign.each_key do |key|
      case key
      when '@uri'
        campaign[key] = campaign[key].sub(%r{(trafficking\/campaigns\/)([^\?]+)}, "\\1#{id}")
      when 'campaign_id'
        campaign[key] = id
      when 'campaign_key'
        campaign[key] = "key#{id}"
      when 'advertiser_id'
        campaign[key] = 1
      when 'campaign_name'
        campaign[key] = "Campaign #{id}"
      end
    end
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~ %r{trafficking\/campaigns\/sample-campaign-id(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    anonymize_campaign.call(response, 'sample-campaign-id')

    interaction.response.body = response.to_json
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~ %r{trafficking\/campaigns(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']
    items.each_with_index do |item, index|
      anonymize_campaign.call(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end
end
