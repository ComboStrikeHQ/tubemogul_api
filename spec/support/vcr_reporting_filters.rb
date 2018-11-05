# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-media-placement-id') { ENV.fetch('SAMPLE_MEDIA_PLACEMENT_ID') }

  MEDIA_PLACEMENTS_REPORT_URI_REGEXP = %r{v2\/reporting\/media_placements(\?.*)?\z}
  PLACEMENTS_FOR_MEDIA_PLACEMENT_REPORT_URI_REGEXP =
    %r{v2\/reporting\/media_placements\/[^\/]+/placements(\?.*)?\z}

  c.before_record do |interaction|
    next unless interaction.request.uri.match?(MEDIA_PLACEMENTS_REPORT_URI_REGEXP)

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']

    if ENV.fetch('SAMPLE_MEDIA_PLACEMENT_ID') == 'sample-media-placement-id'
      puts 'Add to your .env.test file:'
      puts "SAMPLE_MEDIA_PLACEMENT_ID: '#{items.first['media_placement_id']}'"
    end

    items.each_with_index do |item, index|
      Anonymize.media_placement(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end

  c.before_record do |interaction|
    next unless interaction.request.uri.match?(PLACEMENTS_FOR_MEDIA_PLACEMENT_REPORT_URI_REGEXP)

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']

    if ENV.fetch('SAMPLE_PLACEMENT_ID') == 'sample-placement-id'
      puts 'Add to your .env.test file:'
      puts "SAMPLE_PLACEMENT_ID: '#{items.first['placement_id']}'"
    end

    items.each_with_index do |item, index|
      Anonymize.placement(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end
end
