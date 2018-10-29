# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-media-placement-id') { ENV.fetch('SAMPLE_MEDIA_PLACEMENT_ID') }

  c.before_record do |interaction|
    next unless interaction.request.uri =~
        %r{v2\/reporting\/media_placements(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']
    items.each_with_index do |item, index|
      Anonymize.media_placement(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end

  c.before_record do |interaction|
    next unless interaction.request.uri =~
        %r{v2\/reporting\/media_placements\/[^\/]+/placements(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    items = response['items']
    offset = response['paging']['offset']
    items.each_with_index do |item, index|
      Anonymize.placement(item, index + offset + 1)
    end

    interaction.response.body = response.to_json
  end
end
