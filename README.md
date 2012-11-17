# Gridinit::Jmeter

Tired of using the JMeter GUI or looking at hairy XML files?

This gem lets you write test plans for JMeter in your favourite text editor, and optionally run them on gridinit.com

## Installation

Install it yourself as:

    $ gem install gridinit-jmeter

## Usage

A basic test plan

```ruby
require 'gridinit-jmeter'

test do

  threads(num_threads: 100) do

    transaction(name: 'First time visitor') do

      visit(url: 'http://127.0.0.1:4567/') do
        extract(name: 'csrf-token', regex: "content='(.+?)' name='csrf-token'")
      end

      submit(
        url: 'http://127.0.0.1:4567/',
        args: {
          username: 'tim',
          password: 'password',
          'csrf-token' => '${csrf-token}'
        }
      ) 

    end

  end

end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
