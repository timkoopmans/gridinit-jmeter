$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

# To build a test plan, call the method .jmx 
# at the end of your test plan definition.

test do
  threads 100 do
    random_timer 5000,5000
  
    transaction 'Dummy Scenario' do
      visit 'Home Page', 'http://127.0.0.1:4567/' do
        extract 'csrf-token', "content='(.+?)' name='csrf-token'"
      end

      random_timer 3000
  
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