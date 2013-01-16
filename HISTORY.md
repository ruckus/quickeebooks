## 0.1.1 (2013-01-16)

* Quickeebooks can now re-authorize a token via `Quickeebooks::Shared::Service::AccessToken.reconnect`. In addition destroying an access token can now be done via `Quickeebooks::Shared::Service::AccessToken.disconnect`. Thank you to `FundingGates` for the contribution.

## 0.1.0 (2013-01-16)

* Quickbooks Online now supports a single HTTP endpoint for API calls, no need to first determine the Base URL. `Quickeebooks::Online::ServiceBase` has been adjusted to use a single API endpoint.

## < 0.0.9

History was not being tracked so there is no changelog of activity before `0.0.9`