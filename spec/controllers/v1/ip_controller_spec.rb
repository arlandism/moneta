require 'rails_helper'

RSpec.describe V1::IpController do
  describe '#log' do
    it 'creates a log record for every ip' do
      ips = ["127.0.0.1", "0:0:0:0:0:0:0:1"]
      post :log, params: { ips: ips }
      expect(IpVisit.where(ip: ips).count).to eq(2)
    end

    it 'only creates one record per ip, even with dupes' do
      ips = ["127.0.0.1", "127.0.0.1"]
      post :log, params: { ips: ips }
      stored_ips = IpVisit.where(ip: ips)
      expect(stored_ips.count).to eq(1)
      expect(stored_ips[0].ip).to eq("127.0.0.1")
    end

    it 'does not error given duplicate ips across requests' do
      ips = ["127.0.0.1"]
      post :log, params: { ips: ips }
      post :log, params: { ips: ips }
      expect(IpVisit.where(ip: ips).count).to eq(1)
    end

    it 'rejects writes over 1,000' do
      ips = []
      1_001.times do
        ips << "127.0.0.1"
      end
      post :log, params: { ips: ips }
      expect(response.status).to eq(413)
    end
  end

  describe '#seen' do
    it 'returns true for seen ips and false for unseen ips' do
      ips = ["127.0.0.1", "0:0:0:0:0:0:0:1"]
      post :log, params: { ips: ips }
      random_ip = '192.168.100.1'
      post :seen, params: { ips: ips + [random_ip] }
      resp = JSON.parse(response.body)
      expect(resp[ips[0]]).to eq(true)
      expect(resp[ips[1]]).to eq(true)
      expect(resp[random_ip]).to eq(false)
    end

    it 'rejects writes over 1,000' do
      ips = []
      1_001.times do
        ips << "127.0.0.1"
      end
      post :seen, params: { ips: ips }
      expect(response.status).to eq(413)
    end
  end

  describe '#distinct' do
    it 'counts the distinct ips' do
      ips = ["127.0.0.1", "0:0:0:0:0:0:0:1"]
      post :log, params: { ips: ips }
      get :distinct
      resp = JSON.parse(response.body)
      expect(resp["count"]).to eq(2)
    end
  end
end
