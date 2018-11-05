# TubemogulApi [![CircleCI](https://circleci.com/gh/ad2games/tubemogul_api.svg?style=svg)](https://circleci.com/gh/ad2games/tubemogul_api)

Unofficial client library for [Tubemogul API](https://www.tubemogul.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tubemogul_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tubemogul_api

## Usage

```ruby
# If you use the default ENV variables TUBEMOGUL_CLIENT_ID and TUBEMOGUL_SECRET_KEY, you can get a
# connection by:

connection = TubemogulApi::Connection.new

# Otherwise you can explicitly pass client_id and secret_key:
connection = TubemogulApi::Connection.new(
  client_id: ENV.fetch('TUBEMOGUL_CLIENT_ID'),
  secret_key: ENV.fetch('TUBEMOGUL_SECRET_KEY')
)

service = TubemogulApi::Service::Advertiser.new(connection)
service.get(10) # returns the advertiser with the ID 10
service.get_all # returns all advertisers
```

Note: Currently only `get` and `get_all` requests are implemented and for a limited set of services. 
Check `lib/tubemogul_api/service` directory to see which services are available.

Also the `spec/integration` directory contains usage examples.

## Development

Run specs with `bundle exec rspec`.

To recreate or create new VCR episodes, you need to set proper values for env vars. Check .env to 
see the list of env variables required. We recommend that you set it in `.env.test` file.
 
Note that some specs fail when recording new VCR episodes due to filtering of sensitive data.
But after that, all specs should pass in playback mode.

We run `rake rubocop` to make sure, everything looks good.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TubemogulApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ad2games/tubemogul_api/blob/master/CODE_OF_CONDUCT.md).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ad2games/tubemogul_api.
