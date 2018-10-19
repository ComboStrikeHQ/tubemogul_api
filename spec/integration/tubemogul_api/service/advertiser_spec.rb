# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TubemogulApi::Service::Advertiser, :vcr do
  subject(:service) { described_class.new(connection) }

  let(:connection) { TubemogulApi::Connection.new }
  let(:sample_advertiser_id) { ENV.fetch('SAMPLE_ADVERTISER_ID') }

  it 'receives a single advertiser' do
    response = service.get(sample_advertiser_id)

    expect(response.advertiser_id).to eq(sample_advertiser_id)
    expect(response.advertiser_name).to eq("Advertiser #{sample_advertiser_id}")
    expect(response.status).to eq('Active')
  end

  it 'receives multiple advertisers' do
    response = service.get_all(limit: 5).to_a

    expect(response.size).to eq(8)

    expect(response.first.advertiser_id).to eq(1)
    expect(response.first.advertiser_name).to eq('Advertiser 1')
    expect(response.first.status).to eq('Active')

    expect(response.last.advertiser_id).to eq(8)
    expect(response.last.advertiser_name).to eq('Advertiser 8')
    expect(response.last.status).to eq('Active')
  end

  it 'receives an http status error' do
    expect { service.get(999999) }
      .to raise_error(TubemogulApi::NotFound, /The advertiser with id 999999 not found./)
  end
end
