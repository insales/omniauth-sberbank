# OmniAuth Sberbank

This is the unofficial [OmniAuth](https://github.com/intridea/omniauth) strategy for authenticating to SberID via OAuth.
To use it, you'll need to sign up for an OAuth2 Application ID and Secret
on the [Sberbank Developers Page](https://developer.sberbank.ru/).

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-sberbank'
```

Then `bundle install`

## Usage

`OmniAuth::Strategies::Sberbank` is simply a Rack middleware.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
provider :sberbank,
  client_id: '11111111-1111-1111-1111-1111111111111111',
  client_secret: 'YOURSECRET',
  response_type: 'code',
  client_type: 'PRIVATE',
  client_options: { ssl: { client_key: client_key, client_cert: client_cert } },
  scope: 'openid name email mobile',
  callback_path: '/callback',
  grant_type: 'client_credentials'
```

[See the example Rails app](https://github.com/Sergei825/omniauth-sberbank/blob/master/examples).

## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`
All variants see in [Sber documentation](https://developer.sberbank.ru/doc/v1/sberbank-id/info)


## Authentication Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{"provider"=>"sberbank",
 "uid"=>"1",
 "info"=>
  { "name": "Ivanov Ivan Ivanovich",
    "phone_number": "+7 (800) 2223535",
    "email": "DEMO@DEMO.COM",
    "first_name": "IVAN",
    "last_name": "Ivanov",
    "middle_name": "Ivanovich",
    "id": "1111-1111111111"},
 "credentials"=>
  {"token"=>
    "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3",
   "expires_at"=>1381826003,
   "expires"=>true},
 "extra"=>
  {"raw_info"=>
    {}}
```

The precise information available may depend on the permissions which you request.

## Supported Rubies

Tested with the following Ruby versions:

- Ruby MRI (2.6.6+)

## Contributing to omniauth-sberbank

* Fork, fix, then send me a pull request.

## License

Copyright: 2021-2021 Sergei Baksheev (sergbaksheev825@gmail.com)

This library is distributed under the MIT license. Please see the LICENSE file.
