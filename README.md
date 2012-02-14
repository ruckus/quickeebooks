Quickeebooks
============

Integration with Quickbooks Online via the Intuit Data Services REST API.

This library communicates with the Quickbooks Data Services v3 API, documented at:

https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services

Requirements
============

This is being developed on Ruby 1.9.2. Other versions/VMs are untested but Ruby 1.8 should work in theory.

Dependencies
============

Quickbooks Data Services uses OAuth for client authorization. The `oauth` gem is a required dependency. XML is parsed with `Nokogiri`

Getting Started
===============

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
=> [ #<Quickeebooks::Model::Customer:0x007f8e29259770>, #<Quickeebooks::Model::Customer:0x0078768202020>, ... ]
```

Quickbooks API requires that all HTTP operations are performed against a client-specific "Base URL", as discussed here:

https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0010_Getting_the_Base_URL

Quickeebooks will attempt to determine the base URL for the given OAuth client and Realm. This comes at the cost of the overhead of making that initial request. A customers Base URL should not change so if you know it ahead of time then you can specify it as the third argument to the service constructor. For example:

```ruby
customer_service = Quickeebooks::Service::Customer.new(oauth_client, realm_id, "https://qbo.intuit.com/qbo36")
```

Author
======

Cody Caughlan