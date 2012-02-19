# Quickeebooks

Integration with Quickbooks Online via the Intuit Data Services REST API.

This library communicates with the Quickbooks Data Services v3 API, documented at:

https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services

## Requirements

Gems:

* `oauth`
* `roxml` : Workhorse for (de)serializing objects between Ruby & XML
* `nokogiri` : XML parsing
* `active_model` : For validations

This is being developed on Ruby 1.9.2. Other versions/VMs are untested but Ruby 1.8 should work in theory.

## Dependencies

Quickbooks Data Services uses OAuth for client authorization. The `oauth` gem is a required dependency. XML is parsed with `Nokogiri`

## Getting Started

This library assumes you already have an OAuth token and secret. You can then initialize your `OAuth Consumer` and create a `OAuth Client` via:

```ruby
QB_KEY = "your-qb-key"
QB_SECRET = "your-qb-secret"

qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_path       => "/oauth/v1/get_access_token",
    :access_token_path    => "/oauth/v1/get_access_token"
})

oauth_client = OAuth::ConsumerToken.new(qb_oauth_consumer, access_token, access_secret)
```

Now we can initialize any of the `Service` clients:

```ruby
customer_service = Quickeebooks::Service::Customer.new(oauth_client, realm_id)
customer_service.list 

# returns a `Collection` object
```

See *Retrieving Objects* for the complete docs on fetching collections.

Quickbooks API requires that all HTTP operations are performed against a client-specific "Base URL", as discussed here:

https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0010_Getting_the_Base_URL

Quickeebooks will attempt to determine the base URL for the given OAuth client and Realm. This comes at the cost of the overhead of making that initial request. A customers Base URL should not change so if you know it ahead of time then you can specify it as the third argument to the service constructor. For example:

```ruby
customer_service = Quickeebooks::Service::Customer.new(oauth_client, realm_id, "https://qbo.intuit.com/qbo36")
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
customer_service = Quickeebooks::Service::Customer.new(oauth_client, realm_id,)
# fetch all customers with default parameters (pagination, sorting, filtering)
customers = customer_service.list
```

Return result: a `Collection` instance with properties: `entries`, `current_page`, `count` which should be self-explanatory.

### Filtering

All filters in the Intuit documentation are supported: text, datetime, boolean.

Construct an instance of `Quickeebooks::Service::Filter` with the type of filter, one of: `:text`, `:datetime`, `:boolean`.

Pass an array of `Quickeebooks::Service::Filter` objects as the first argument to the Services `list` method and all filters will be applied.

#### Filtering on a text field

Specify a type of `:text` and your desired `:field` and a `:value` clause which will enforce an exact match.

Note: the Intuit API is case-INSENSITIVE.

```ruby
Quickeebooks::Service::Filter.new(:text, :field => 'FamilyName', :value => 'Richards')
```

#### Filtering on a Date/Time

Specify a type of `:datetime` and your desired `:field` than any combination of: `:before` and `:after`

Examples:

```ruby
# find all customers created after 2/15/2011
datetime = Time.mktime(2011, 2, 15)
Quickeebooks::Service::Filter.new(:datetime, :field => 'CreateTime', :after => datetime)

# find all customers created before 3/28/2011
datetime = Time.mktime(2011, 2, 28)
Quickeebooks::Service::Filter.new(:datetime, :field => 'CreateTime', :before => datetime)

# find all customers created between 1/1/2011 and 2/15/2011
after = Time.mktime(2011, 1, 1)
before = Time.mktime(2011, 2, 15
Quickeebooks::Service::Filter.new(:datetime, :field => 'CreateTime', :after => after, :before => before)
```

#### Filtering on a Boolean field

Specify a type of `:boolean` and your desired `:field` and a `:value` with either `true` or `false`

```ruby
# find all customers and exclude jobs
Quickeebooks::Service::Filter.new(:boolean, :field => 'IncludeJobs', :value => false)
```

Once you have created all of your `Filters` than just pass an array of them to any services `list` method and they will all be applied.

Example: find all Customers with a last name of 'Richards' who have been created before Feb 25, 2012:

```ruby
filters = []
filters << Quickeebooks::Service::Filter.new(:text, :field => 'FamilyName', :value => 'Richards')
datetime = Time.mktime(2011, 2, 25)
filters << Quickeebooks::Service::Filter.new(:datetime, :field => 'CreateTime', :before => datetime)
customer_service = Quickeebooks::Service::Customer.new(oauth_client, realm_id)
customers = customer_service.list(filters)
```
## Sorting

Create an instance of `Quickeebooks::Service::Sort` where the first argument is the field and the second is the sorting direction/logic.

See https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0030_Retrieving_Objects#Sorting for the complete set of sorting options.

Example

```ruby
sorter = Quickeebooks::Service::Sort.new('FamilyName', 'AtoZ')
```

## Bringing it all together

Goal: fetch all customers with a last name of Smith starting at the first page with a per page size of 30, created between May and August of 2011 and sort by last name from A-to-Z.

```ruby
filters = []
filters << Quickeebooks::Service::Filter.new(:text, :field => 'FamilyName', :value => 'Smith')

d1 = Time.mktime(2011, 5, 1)
d2 = Time.mktime(2011, 8, 1)
filters << Quickeebooks::Service::Filter.new(:datetime, :field => 'CreateTime', :after => d1, :before => d2)

sorter = Quickeebooks::Service::Sort.new('FamilyName', 'AtoZ')

customer_service = Quickeebooks::Service::Customer.new(oauth_client, realm_id)
customers = customer_service.list(filters, 1, 30, sort)

# returns
 
customers.count
=> 67

customers.current_page
=> 1

customers.entries 
=> [ #<Quickeebooks::Model::Customer:0x007f8e29259770>, #<Quickeebooks::Model::Customer:0x0078768202020>, ... ]
```

## Author

Cody Caughlan