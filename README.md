# Gridinit::Jmeter

Tired of using the JMeter GUI or looking at hairy XML files?

This gem lets you write test plans for JMeter in your favourite text editor, and optionally run them on gridinit.com

## Installation

Install it yourself as:

    $ gem install gridinit-jmeter

## Usage

*Gridinit::Jmeter* exposes easy-to-use domain specific language for fluent communication with [JMeter](http://jmeter.apache.org/). As the name of the gem suggests, it also includes API integration with [Gridinit](http://gridinit.com), a cloud based load testing service.

To use the DSL, first let's require the gem:

```ruby
require 'rubygems'
require 'gridinit-jmeter'
```

Let's create a `test` and save the related `jmx` testplan to file, so we can edit/view it in JMeter.

```ruby
test do
  threads 10 do
    visit 'Google Search', 'http://google.com'
  end
end.jmx
```

```ruby
test do
  random_timer delay: 5000, range: 5000
  threads num_threads: 10, loops: 10 do
    transaction 'Dummy Scenario' do
      visit 'Home Page', 'http://127.0.0.1:4567/' do
        extract 'csrf-token', "content='(.+?)' name='csrf-token'"
      end
   
      submit 'Submit Form', 'http://127.0.0.1:4567/', {
        fill_in: {
          username: 'tim',
          password: 'password',
          'csrf-token' => '${csrf-token}'
        }
      }
    end
  end
end.jmx
```

## Roadmap

This is very much a work-in-progress. Future work is being sponsored by Gridinit.com. Get in touch with us if you'd like to be involved.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
