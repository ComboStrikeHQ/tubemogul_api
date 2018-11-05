# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TubemogulApi::Service::Reporting, :vcr do
  subject(:service) { described_class.new(connection) }

  let(:connection) { TubemogulApi::Connection.new }

  it 'get reporting for all media placements' do
    response = service.get('media_placements', start_day: '2018-03-11', end_day: '2018-03-11').to_a

    record = response.first
    expect(record.media_placement_id).to eq(1)
    expect(record.media_placement_name).to eq('Media Placement 1')
    expect(record.media_property_id).to eq('media-property-id')
    expect(record.media_property_name).to eq('Media Property Name')

    data = record.stats['buckets'].first['data']
    expect(data['views']).to eq(8596)
    expect(data['completions100']).to eq(5825)
  end

  it 'get placements reporting for specific media placament' do
    url = "media_placements/#{ENV.fetch('SAMPLE_MEDIA_PLACEMENT_ID')}/placements"
    response = service.get(url, start_day: '2018-03-11', end_day: '2018-03-11').to_a

    record = response.first
    expect(record.placement_id).to eq(1)
    expect(record.placement_name).to eq('Placement 1')

    data = record.stats['buckets'].first['data']
    expect(data['views']).to eq(8596)
    expect(data['completions100']).to eq(5825)
  end
end
