# frozen_string_literal: true

module Anonymize
  def advertiser(record, id)
    record.each_key do |key|
      case key
      when 'advertiser_id'
        record[key] = id
      when '@uri'
        record[key] = record[key].sub(%r{(trafficking\/advertisers\/)([^\?]+)}, "\\1#{id}")
      when 'advertiser_name'
        record[key] = "Advertiser #{id}"
      when 'advertiser_domain'
        record[key] = "https://#{id}.example.com"
      end
    end
  end
  module_function :advertiser

  def campaign(record, id)
    record.each_key do |key|
      case key
      when '@uri'
        record[key] = record[key].sub(%r{(trafficking\/campaigns\/)([^\?]+)}, "\\1#{id}")
      when 'campaign_id'
        record[key] = id
      when 'campaign_key'
        record[key] = "key#{id}"
      when 'advertiser_id'
        record[key] = 1
      when 'campaign_name'
        record[key] = "Campaign #{id}"
      end
    end
  end
  module_function :campaign

  def placement(record, id)
    if id == 1 && ENV.fetch('SAMPLE_PLACEMENT_ID') == 'sample-placement-id'
      puts 'Add to your .env.test file:'
      puts "SAMPLE_PLACEMENT_ID: '#{item['placement_id']}'"
    end
    record.each_key do |key|
      case key
      when 'placement_id'
        record[key] = id
      when 'placement_key'
        record[key] = "placementkey#{id}"
      when '@uri'
        if record['@type'] == 'placement'
          record[key] = record[key].sub(%r{(trafficking\/placements\/)([^\?]+)}, "\\1#{id}")
        elsif record['@type'] == 'placement_report'
          record[key] = record[key].sub(%r{(reporting\/placements\/)\d+(\??.*)}, "\\1#{id}\\2")
        end
      when 'placement_name'
        record[key] = "Placement #{id}"
      when 'campaign_id'
        record[key] = '1'
      when 'campaign_key'
        record[key] = 'key1'
      when 'campaign_name'
        record[key] = 'Campaign 1'
      end
    end
  end
  module_function :placement

  def media_placement(record, id)
    if id == 1 && ENV.fetch('SAMPLE_MEDIA_PLACEMENT_ID') == 'sample-media-placement-id'
      puts 'Add to your .env.test file:'
      puts "SAMPLE_MEDIA_PLACEMENT_ID: '#{record['media_placement_id']}'"
    end
    record.each_key do |key|
      case key
      when 'media_placement_id'
        record[key] = id
      when '@uri'
        record[key] = record[key].sub(%r{(reporting\/media_placements\/)\d+(\??.*)}, "\\1#{id}\\2")
      when 'media_placement_name'
        record[key] = "Media Placement #{id}"
      when 'media_property_id'
        record[key] = 'media-property-id'
      when 'media_property_name'
        record[key] = 'Media Property Name'
      end
    end
  end
  module_function :media_placement
end
