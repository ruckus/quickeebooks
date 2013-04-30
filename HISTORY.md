## 0.1.6 (2013-04-29)

* Online: TimeActivity provided by epugh

## 0.1.6 (2013-04-08)

* Online: Moved Shipping and Billing properties from the Invoice model to the InvoiceHeader model where they belong.

## 0.1.5 (2013-03-30)

* Added Address convenience assignment methods to Online Customer model.

## 0.1.4 (2013-03-24)

* Refactored `Filter` and separated the handling of `Date` and `DateTime`. Also refactored how operational XML is generated and removed hard-coded XML scattered in classes in favor of a centralized mechanism for generating generic XML.

## 0.1.2 (2013-01-18)

* Fixed issue where an instance of `ActiveSupport::TimeWithZone` was given to a `:datetime` Filter and the resultant format was not being correctly parsed by Intuit.

## 0.1.1 (2013-01-16)

* Quickeebooks can now re-authorize a token via `Quickeebooks::Shared::Service::AccessToken.reconnect`. In addition destroying an access token can now be done via `Quickeebooks::Shared::Service::AccessToken.disconnect`. Thank you to `FundingGates` for the contribution.

## 0.1.0 (2013-01-16)

* Quickbooks Online now supports a single HTTP endpoint for API calls, no need to first determine the Base URL. `Quickeebooks::Online::ServiceBase` has been adjusted to use a single API endpoint.

## < 0.0.9

History was not being tracked so there is no changelog of activity before `0.0.9`