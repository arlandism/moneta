# Moneta

## API

Moneta supports 3 API operations:
* Log a single visit from a list of IP addresses. Multiple visits must be logged as separate API calls.
** "POST /v1/log"
** Conceptually, this can be thought of as a call to "increment" (e.g. add 1 to (current_ip_count || 0)).
* A boolean style query to determine whether a given list of IP addresses has ever been "seen" by the system.
** "POST /v1/seen"
* A count of the total number of unique IPs ever "seen" by the system.
** "GET /v1/distinct"

The first 2 operations support up to 1,000 IP addresses in a single query, with anything over being rejected.
