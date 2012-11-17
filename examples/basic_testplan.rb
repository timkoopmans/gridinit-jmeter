$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

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