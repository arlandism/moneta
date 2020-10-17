require 'ipaddr'

class IPService
  def record_ips(ips:)
    visits = ips.map {|ip| IpVisit.new(ip: ip) }
    IpVisit.import(visits, on_duplicate_key_ignore: true)
  end

  def have_seen?(ips:)
    stored = IpVisit.where(ip: ips).select(:ip).index_by {|visit| visit.ip.to_i }

    results = ips.reduce({}) do |acc, ip|
      acc[ip] = stored.key?(IPAddr.new(ip).to_i)
      acc
    end
  end

  # https://www.citusdata.com/blog/2016/10/12/count-performance/#distinct_counts_exact
  # Interestingly, a vanilla count(distinct) doesn't leverage indices, but the subquery
  # version does.
  def count_unique
    IpVisit.connection.execute(
      "SELECT COUNT(*) FROM (SELECT DISTINCT(ip) FROM ip_visits) as dist"
    ).to_a[0]
  end
end
