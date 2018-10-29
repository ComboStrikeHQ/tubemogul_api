# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-placement-id') { ENV.fetch('SAMPLE_PLACEMENT_ID') }

  c.before_record do |interaction|
    next unless interaction.request.uri =~ %r{trafficking\/placements\/sample-placement-id(\?.*)?\z}

    response = JSON.parse(interaction.response.body)
    Anonymize.placement(response, 'sample-placement-id')

    interaction.response.body = response.to_json
  end
end
