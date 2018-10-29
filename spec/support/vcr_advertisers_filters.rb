# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-advertiser-id') { ENV.fetch('SAMPLE_ADVERTISER_ID') }

  c.before_record do |interaction|
    next unless interaction.request.uri =~
        %r{trafficking\/advertisers\/sample-advertiser-id(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    Anonymize.advertiser(response, 'sample-advertiser-id')

    interaction.response.body = response.to_json
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~ %r{trafficking\/advertisers\/?(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']
    items.each_with_index do |item, index|
      Anonymize.advertiser(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end
end
