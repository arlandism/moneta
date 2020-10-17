require 'ipaddr'

module V1
  class IpController < ApplicationController
    before_action :validate_ip_payload_size
    skip_before_action :validate_ip_payload_size, only: [:distinct]

    def log
      ips = request.params['ips'].map {|ip| IpVisit.new(ip: ip) }
      IpVisit.import(ips, on_duplicate_key_ignore: true)
      head 201
    end

    def seen
      stored = IpVisit.where(ip: request.params['ips']).select(:ip).reduce({}) do |acc, ip|
        acc[ip.ip.to_i] = true
        acc
      end

      results = request.params['ips'].reduce({}) do |acc, ip|
        acc[ip] = stored.key?(IPAddr.new(ip).to_i)
        acc
      end
      render json: results
    end

    def distinct
      render json:
        IpVisit.connection.execute("SELECT COUNT(*) FROM (SELECT DISTINCT(ip) FROM ip_visits) as dist").to_a[0]

    end

    private

    def validate_ip_payload_size
      head 413 if request.params['ips'] && request.params['ips'].length > 1_000
    end
  end
end
