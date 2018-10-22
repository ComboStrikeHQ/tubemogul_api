# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TubemogulApi::Service::Campaign, :vcr do
  subject(:service) { described_class.new(connection) }

  let(:connection) { TubemogulApi::Connection.new }
  let(:sample_campaign_id) { ENV.fetch('SAMPLE_CAMPAIGN_ID') }

  it 'receives a single campaign' do
    response = service.get(sample_campaign_id)

    expect(response.campaign_id).to eq(sample_campaign_id)
    expect(response.campaign_name).to eq("Campaign #{sample_campaign_id}")
    expect(response.campaign_key).to eq("key#{sample_campaign_id}")
    expect(response.advertiser_id).to eq(1)
    expect(response.status).to eq('Active')
  end

  it 'receives multiple campaigns' do
    response = service.get_all.to_a

    expect(response.size).to eq(10)

    expect(response.first.campaign_id).to eq(1)
    expect(response.first.campaign_key).to eq('key1')
    expect(response.first.campaign_name).to eq('Campaign 1')
    expect(response.first.advertiser_id).to eq(1)
    expect(response.first.status).to eq('Active')

    expect(response.last.campaign_id).to eq(10)
    expect(response.last.campaign_name).to eq('Campaign 10')
    expect(response.last.advertiser_id).to eq(1)
    expect(response.last.status).to eq('Active')
  end

  it 'receives an http status error' do
    expect { service.get(999999) }
      .to raise_error(TubemogulApi::NotFound, /The campaign with id 999999 not found./)
  end
end
