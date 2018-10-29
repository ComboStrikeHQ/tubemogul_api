# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-campaign-id') { ENV.fetch('SAMPLE_CAMPAIGN_ID') }

  SINGLE_CAMPAIGN_URI_REGEXP = %r{trafficking\/campaigns\/sample-campaign-id(\?.*)?\z}
  MULTIPLE_CAMPAIGNS_URI_REGEXP = %r{trafficking\/campaigns\/?(\?.*)?\z}

  c.before_record do |interaction|
    next unless interaction.request.uri.match?(SINGLE_CAMPAIGN_URI_REGEXP)

    response = JSON.parse(interaction.response.body)
    Anonymize.campaign(response, 'sample-campaign-id')

    interaction.response.body = response.to_json
  end

  c.before_record do |interaction|
    next unless interaction.request.uri.match?(MULTIPLE_CAMPAIGNS_URI_REGEXP)

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']
    items.each_with_index do |item, index|
      Anonymize.campaign(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end
end
