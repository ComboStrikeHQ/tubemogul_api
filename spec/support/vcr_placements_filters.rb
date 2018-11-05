# frozen_string_literal: true

VCR.configure do |c|
  c.filter_sensitive_data('sample-placement-id') { ENV.fetch('SAMPLE_PLACEMENT_ID') }

  SINGLE_PLACEMENT_URI_REGEXP = %r{trafficking\/placements\/sample-placement-id(\?.*)?\z}

  c.before_record do |interaction|
    next unless interaction.request.uri.match?(SINGLE_PLACEMENT_URI_REGEXP)

    response = JSON.parse(interaction.response.body)
    Anonymize.placement(response, 'sample-placement-id')

    interaction.response.body = response.to_json
  end
end
