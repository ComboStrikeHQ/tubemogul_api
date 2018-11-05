# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TubemogulApi::Service::Placement, :vcr do
  subject(:service) { described_class.new(connection) }

  let(:connection) { TubemogulApi::Connection.new }
  let(:sample_placement_id) { ENV.fetch('SAMPLE_PLACEMENT_ID') }

  it 'receives a single placement' do
    response = service.get(ENV.fetch('SAMPLE_PLACEMENT_ID'))
    expect(response.ad_template).to eq('connected_tv_30')
  end
end
