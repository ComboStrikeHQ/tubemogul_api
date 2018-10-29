# frozen_string_literal: true

module Anonymize
  def advertiser(record, id)
    replace(
      record,
      'advertiser_id' => id,
      '@uri' => record['@uri'].sub(%r{(trafficking\/advertisers\/)([^\?]+)}, "\\1#{id}"),
      'advertiser_name' => "Advertiser #{id}",
      'advertiser_domain' => "https://#{id}.example.com"
    )
  end
  module_function :advertiser

  def campaign(record, id)
    replace(
      record,
      '@uri' => record['@uri'].sub(%r{(trafficking\/campaigns\/)([^\?]+)}, "\\1#{id}"),
      'campaign_id' => id,
      'campaign_key' => 'key1',
      'advertiser_id' => 1,
      'campaign_name' => "Campaign #{id}"
    )
  end
  module_function :campaign

  def placement(record, id)
    replace(
      record,
      'placement_id' => id,
      'placement_key' => "placementkey#{id}",
      '@uri' => placement_uri(record, id),
      'placement_name' => "Placement #{id}",
      'campaign_id' => 1,
      'campaign_key' => 'key1',
      'campaign_name' => 'Campaign 1'
    )
  end
  module_function :placement

  def placement_uri(record, id)
    if record['@type'] == 'placement'
      record['@uri'].sub(%r{(trafficking\/placements\/)([^\?]+)}, "\\1#{id}")
    elsif record['@type'] == 'placement_report'
      record['@uri'].sub(%r{(reporting\/placements\/)\d+(\??.*)}, "\\1#{id}\\2")
    end
  end
  module_function :placement_uri

  def media_placement(record, id)
    replace(
      record,
      'media_placement_id' => id,
      '@uri' => record['@uri'].sub(%r{(reporting\/media_placements\/)\d+(\??.*)}, "\\1#{id}\\2"),
      'media_placement_name' => "Media Placement #{id}",
      'media_property_id' => 'media-property-id',
      'media_property_name' => 'Media Property Name'
    )
  end
  module_function :media_placement

  def replace(original, replacement)
    replacement.each do |key, value|
      original[key] = value if original.key?(key)
    end
  end
  module_function :replace
end
