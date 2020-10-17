# Moneta

## Running
NOTE: This assumes port 3000 is available on the host machine.

To build for the first time, run:
* `docker-compose run web bundle install`
* `docker-compose build`
* `docker-compose run web rails db:create`
* `docker-compose run web rails db:migrate`

To run tests:
* `docker-compose run web bundle exec rspec`

To run the service:
* `docker-compose up`

This will expose the webserver on port 3000.

To get started with the API, here are some cURL commands:

* ```curl localhost:3000/v1/log -XPOST -H "Content-type: application/json" -d '{"ips": ["192.168.0.0", "2001:4f8:3:ba:2e0:81ff:fe22:d1f1"]}'```

* ```curl localhost:3000/v1/seen -XPOST -H "Content-type: application/json" -d '{"ips": ["192.168.0.0", "2001:4f8:3:ba:2e0:81ff:fe22:d1f1", "192.168.0.1"]}'```

* `curl localhost:3000/v1/distinct`

### Troubleshooting

If any of the above steps fail try rebuilding the container ala `docker-compose build`

## API

Moneta can be thought of as a "set" of ip visits. There's no notion of duplicity and duplicate writes have no effect.

Moneta supports 3 API operations:
* Log a single visit from a list of IP addresses.
    * `POST /v1/log`
* A boolean style query to determine whether a given list of IP addresses has ever been "seen" by the system.
    * `POST /v1/seen`
* A count of the total number of unique IPs ever "seen" by the system.
    * `GET /v1/distinct`

The first 2 operations support up to 1,000 IP addresses in a single query, with anything over being rejected.
Both ipv4 and ipv6 address formats are supported.

