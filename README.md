# Quickeebooks

Integration with Quickbooks Online via the Intuit Data Services REST API.

This library communicates with the Quickbooks Data Services `v2` API, documented at:

[Data Services v2](https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services)

When Intuit finalizes the `v3` API I would like to move to that version as it appears to be better structured
and has `JSON` request/response formats, which should be easier to work with than XML.

[![Build Status](https://travis-ci.org/ruckus/quickeebooks.png)](https://travis-ci.org/ruckus/quickeebooks)

## Requirements

This is being developed on Ruby REE, 1.9.2 & 1.9.3. Other versions/VMs are untested but stable Rubies should work in theory.

## Dependencies

Gems:

* `oauth`
* `roxml` : Workhorse for (de)serializing objects between Ruby & XML
* `nokogiri` : XML parsing
* `active_model` : For validations

## Getting Started & Initiating Authentication Flow with Intuit

What follows is an example using Rails but the principles can be adapted to any other framework / pure Ruby.

Create a Rails initializer with:

```ruby
QB_KEY = "your apps Intuit App Key"
QB_SECRET = "your apps Intuit Secret Key"

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "/oauth/v1/get_access_token"
})
```

To start the authentication flow with Intuit you include the Intuit Javascript and on a page of your choosing you present the "Connect to Quickbooks" button by including this XHTML:


```HTML
<!-- somewhere in your document include the Javascript -->
<script type="text/javascript" src="https://appcenter.intuit.com/Content/IA/intuit.ipp.anywhere.js"></script>

<!-- configure the Intuit object: 'grantUrl' is a URL in your application which kicks off the flow, see below -->
<script>
intuit.ipp.anywhere.setup({menuProxy: '/path/to/blue-dot', grantUrl: '/path/to/your-flow-start'});
</script>

<!-- this will display a button that the user clicks to start the flow -->
<ipp:connectToIntuit></ipp:connectToIntuit>
```

Your Controller action (the `grantUrl` above) should look like this:

```ruby
  def authenticate
    callback = quickbooks_oauth_callback_url
    token = $qb_oauth_consumer.get_request_token(:oauth_callback => callback)
    session[:qb_request_token] = token
    redirect_to("https://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}") and return
  end
```

Where `quickbooks_oauth_callback_url` is the absolute URL of your application that Intuit should send the user when authentication succeeeds. That action should look like:

```ruby
def oauth_callback
	at = session[:qb_request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
	token = at.token
	secret = at.secret
	realm_id = params['realmId']
	# store the token, secret & RealmID somewhere for this user, you will need all 3 to work with Quickeebooks
end
```

## Creating an OAuth Access Token

Once you have your users OAuth Token & Secret you can initialize your `OAuth Consumer` and create a `OAuth Client` using the `$qb_oauth_consumer` you created earlier in your Rails initializer:

```ruby
oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, access_token, access_secret)
```

## Quickbooks Online vs Windows

IDS provides 2 APIs, one for interacting with Quickbooks Online resources and one for Quickbooks Windows resources.

See: https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services

You will need to be aware of which flavor of the API you want to invoke.

For example:

```ruby
# Instantiate a Online API
customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list

# Instantiate a Windows API
customer_service = Quickeebooks::Windows::Service::Customer.new(oauth_client, realm_id)
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list
```

All of the documentation below is geared towards the Online flavor but unless noted one should be able to replace it with Windows.

Now we can initialize any of the `Service` clients:

```ruby
customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list
customer_service.list

# returns a `Collection` object
```

See *Retrieving Objects* for the complete docs on fetching collections.

Quickbooks API requires that all HTTP operations are performed against a client-specific "Base URL", as discussed here:

Note: The Windows and Online(versions 7.0 and above) now use a static base URL which is the default URL that is used with Quickeebooks so no additional HTTP requests are made.

[Getting the Base URL](https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0010_Getting_the_Base_URL)

Quickeebooks will attempt to determine the base URL for the given OAuth client and Realm. This comes at the cost of the overhead of making that initial request. A customers Base URL should not change so if you know it ahead of time then you can specify it as the third argument to the service constructor. For example:

```ruby
customer_service = Quickeebooks::Online::Service::Customer.new(oauth_client, realm_id, "https://qbo.intuit.com/qbo36")
```

## Retrieving Objects

Use a `Service` sub-class to fetch objects of that resource and specifically use the `list` method.

The signature of the `list` method is:

```ruby
list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
```

Where `filters` is an array of `Filter` objects (see below). Pagination is set to page 1 and 20 results per page by default.
Pass a `Sort` object for any desired sorting or just let Intuit use the default sorting for that resource (see below for more sorting options).

Specify none of these to get the defaults:

```ruby
customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list

# fetch all customers with default parameters (pagination, sorting, filtering)
customers = customer_service.list
```

Return result: a `Collection` instance with properties: `entries`, `current_page`, `count` which should be self-explanatory.

### Filtering (full Online API support, partial Windows API support)

For Online, all filters in the Intuit documentation are supported: text, datetime, boolean.

For Windows, Intuit has a custom API for certain query fields: you cannot search on an arbitrary attributes. See https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0500_QuickBooks_Windows/0100_Calling_Data_Services/0015_Retrieving_Objects#Filtering for more information, and to see which attributes are queryable, see: https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0500_QuickBooks_Windows/0600_Object_Reference/Invoice#section_9

Note: you'll get an exception from Intuit if you attempt to query on a non-queryable attribute.

Construct an instance of `Quickeebooks::Shared::Service::Filter` with the type of filter, one of: `:text`, `:datetime`, `:boolean`.

Pass an array of `Quickeebooks::Shared::Service::Filter` objects as the first argument to the Services `list` method and all filters will be applied.

#### Filtering on a text field

Specify a type of `:text` and your desired `:field` and a `:value` clause which will enforce an exact match.

Note: the Intuit API is case-INSENSITIVE.

```ruby
Quickeebooks::Shared::Service::Filter.new(:text, :field => 'FamilyName', :value => 'Richards')
```

#### Filtering on a Date/Time

Specify a type of `:datetime`, your desired `:field` and finally use `:value` to specify the anchoring date.

Examples:

```ruby
# find all customers created between Feb 1 - 28
# this requires specifying TWO filters, one for the start and another for the end
filters = []
filters << Quickeebooks::Shared::Service::Filter.new(:datetime, :field => 'StartCreatedTMS', :value => Time.mktime(2013, 2, 1))
filters << Quickeebooks::Shared::Service::Filter.new(:datetime, :field => 'EndCreatedTMS', :value => Time.mktime(2013, 2, 28))
```

You will need to consult the Intuit API docs for each entity type to determine what the filterable fields are, as they change from entity to entity. In the above case `Customer` supports both `StartCreatedTMS` and `EndCreatedTMS`

#### Filtering on a Boolean field

Specify a type of `:boolean` and your desired `:field` and a `:value` with either `true` or `false`

```ruby
# find all customers and exclude jobs
Quickeebooks::Shared::Service::Filter.new(:boolean, :field => 'IncludeJobs', :value => false)
```

#### Filtering on a Number

Specify a type of `:number` and an operator, one of: `:gt`, `:lt`, or `:eq`.

```ruby
# find all customers and exclude jobs
Quickeebooks::Shared::Service::Filter.new(:number, :field => 'Amount', :gt => 150)
```

Once you have created all of your `Filters` than just pass an array of them to any services `list` method and they will all be applied.

Example: find all Customers with a last name of 'Richards' who have been created before Feb 25, 2012:

```ruby
filters = []
filters << Quickeebooks::Online::Service::Filter.new(:text, :field => 'FamilyName', :value => 'Richards')
datetime = Time.mktime(2011, 2, 25)
filters << Quickeebooks::Online::Service::Filter.new(:datetime, :field => 'CreateTime', :before => datetime)
customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list

customers = customer_service.list(filters)
```
## Sorting (currently only supported in the Online API)

Create an instance of `Quickeebooks::Service::Sort` where the first argument is the field and the second is the sorting direction/logic.

See [Sorting and Pagination](https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0030_Retrieving_Objects#Sorting) for the complete set of sorting options.

Example

```ruby
sorter = Quickeebooks::Online::Service::Sort.new('FamilyName', 'AtoZ')
```

## Bringing it all together

Goal: fetch all customers with a last name of Smith starting at the first page with a per page size of 30, created between May and August of 2011 and sort by last name from A-to-Z.

```ruby
filters = []
filters << Quickeebooks::Online::Service::Filter.new(:text, :field => 'FamilyName', :value => 'Smith')

d1 = Time.mktime(2011, 5, 1)
d2 = Time.mktime(2011, 8, 1)
filters << Quickeebooks::Online::Service::Filter.new(:datetime, :field => 'CreateTime', :after => d1, :before => d2)

sorter = Quickeebooks::Online::Service::Sort.new('FamilyName', 'AtoZ')

customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list

customers = customer_service.list(filters, 1, 30, sort)

# returns

customers.count
=> 67

customers.current_page
=> 1

customers.entries
=> [ #<Quickeebooks::Online::Model::Customer:0x007f8e29259770>, #<Quickeebooks::Online::Model::Customer:0x0078768202020>, ... ]
```

## Reading a single object

Use the `Service` instance to fetch an object by its id using the `fetch_by_id` method:

```ruby
# fetch the Customer object with an id of 100
customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list

customer = customer_service.fetch_by_id(100)
customer.name
=> John Doe
```

## Writing Objects

Create or fetch an instance of a `Model` object and pass it to the corresponding service `create` or `update` method.

You will need make sure you supply all required fields for that Intuit object, so consult the documentation. For instance the documentation for a `Customer` object is at: [Intuit Customer Object](https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/Customer)

## Creating a single object

Pass an instance of your object to the `create` method on its related Service:

```ruby
customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list

customer = Quickeebooks::Online::Model::Customer.new
customer.name = "Richard Parker"
customer.email = "richard@example.org"
customer_service.create(customer)
```



## Updating a single object

Pass an instance of your object to the `update` method on its related Service:

```ruby
customer_service = Quickeebooks::Online::Service::Customer.new
customer_service.access_token = oauth_client
customer_service.realm_id = realm_id
customer_service.list

customer = customer_service.fetch_by_id(100)
customer.name = "Richard Parker"
customer.email = "richard@example.org"
customer_service.update(customer)
```

# Services

All `Service` objects (`Quickeebooks::Online::Service::Customer`, `Quickeebooks::Online::Service::Account`, `Quickeebooks::Online::Service::Invoice`, etc) have a simple API for CRUD operations. Some service objects have additional functionality (for example the Invoice object can fetch a PDF representation of an invoice). See notes below for each service.

```ruby
create(object)
update(object)
list()
fetch_by_id(object_id)
delete(object)
```

As of `0.1.9` the supported Service operations are:

### Quickbooks Online

Entity            | Create | Update | List | Delete | Fetch by ID | Other
---               | ---    | ---    | ---  | ---    | ---         | ---
Account           | yes    | yes    | yes  | yes    | yes
Bill              | yes    | yes    | yes  | yes    | yes
Bill Payment      | yes    | yes    | yes  | yes    | yes
Class             | yes    | yes    | yes  | yes    | yes
Company Meta Data | no     | no     | no   | no     | no          | `load`
Customer          | yes    | yes    | yes  | yes    | yes         |
Employee          | yes    | yes    | yes  | yes    | yes         |
Entitlement       | n/a    | n/a    | n/a  | n/a    | n/a         | `status`
Invoice           | yes    | yes    | yes  | yes    | yes         | `invoice_as_pdf`
Item              | yes    | yes    | yes  | yes    | yes         |
Journal Entry     | yes    | yes    | yes  | yes    | yes         |
Job               | yes    | yes    | yes  | yes    | yes         |
Payment           | yes    | yes    | yes  | yes    | yes         |
Payment Method    | no     | no     | no   | no     | no          |
Sales Receipt     | yes    | yes    | yes  | yes    | yes         |
Sales Rep         | no     | no     | no   | no     | no          |
Sales Tax         | no     | no     | no   | no     | no          |
Ship Method       | no     | no     | no   | no     | no          |
Sync Activity     | n/a    | n/a    | n/a  | n/a    | n/a         |
Sync Status       | n/a    | n/a    | n/a  | n/a    | n/a         |
Time Activity     | yes    | yes    | yes  | yes    | yes         |
Tracking Class    | yes    | yes    | yes  | yes    | yes         |
Vendor            | yes    | yes    | yes  | yes    | yes         |

### Quickbooks Windows / Desktop

Entity            | Create | Update | List | Delete | Fetch by ID | Other
---               | ---    | ---    | ---  | ---    | ---         | ---
Account           | no     | no     | yes  | no     | no
Bill              | no     | no     | no   | no     | no
Bill Payment      | no     | no     | no   | no     | no
Company Meta Data | no     | no     | no   | no     | no          | `load`
Customer          | yes    | yes    | yes  | no     | yes         |
Employee          | yes    | no     | yes  | no     | no          |
Entitlement       | n/a    | n/a    | n/a  | n/a    | n/a         |
Invoice           | yes    | yes    | yes  | no     | yes         |
Item              | yes    | no     | yes  | no     | yes         |
Journal Entry     | no     | no     | no   | no     | no          |
Payment           | yes    | no     | yes  | no     | yes         |
Payment Method    | no     | no     | yes  | no     | no          |
Sales Receipt     | yes    | no     | yes  | no     | no          |
Sales Rep         | no     | no     | yes  | no     | no          |
Sales Tax         | no     | no     | yes  | no     | no          |
Ship Method       | no     | no     | yes  | no     | no          |
Sync Activity     | no     | no     | no   | no     | no          | `retrieve`
Sync Status       | no     | no     | no   | no     | no          | `retrieve`
Time Activity     | yes    | no     | yes  | no     | no          |
Tracking Class    | n/a    | n/a    | n/a  | n/a    | n/a         |
Vendor            | no     | no     | no   | no     | no          |


## Invoice Service

The `Quickeebooks::Online::Service::Invoice` has the ability to retrieve an invoice as a PDF document:

```ruby
invoice_as_pdf(invoice_id, destination_file_name)
```

Usage: Download invoice #89 and store it at `/tmp/invoice.pdf`:

```ruby
invoice_as_pdf(89, "/tmp/invoice.pdf")
```
_Note:_ it is up to you the caller to remove or clean up the file when you are done.


## Logging

```ruby
Quickeebooks.log = true
```

## Author

Cody Caughlan

## Credits

Thank you for the contributions:

* [Walter McGinnis](https://github.com/walter)
* [Simon Wistow](https://github.com/simonwistow)
* [Matt Rogish](https://github.com/MattRogish)
* [Nick Hammond](https://github.com/nickhammond)
* [Christian Pelczarski](https://github.com/minimul)

## License

The MIT License

Copyright (c) 2012

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
