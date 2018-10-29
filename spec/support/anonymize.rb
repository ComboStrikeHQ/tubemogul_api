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
end
