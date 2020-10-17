$LOAD_PATH << Rails.root
require 'services/ip_service'

module V1
  class IpController < ApplicationController
    before_action :validate_ip_payload_size
    skip_before_action :validate_ip_payload_size, only: [:distinct]

    def log
      IPService.new.record_ips(ips: request.params['ips'])
      head 201
    end

    def seen
      results = IPService.new.have_seen?(ips: request.params['ips'])
      render json: results
    end

    def distinct
      render json: IPService.new.count_unique
    end

    private

    def validate_ip_payload_size
      head 413 if request.params['ips'] && request.params['ips'].length > 1_000
    end
  end
end
