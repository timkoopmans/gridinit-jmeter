$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 100 do
    random_timer 5000,5000
  
    transaction 'Dummy Scenario' do
      visit 'Home Page', 'http://127.0.0.1:4567/' do
        extract 'csrf-token', "content='(.+?)' name='csrf-token'"
      end

      think_time 3000
  
      submit 'Submit Form', 'http://127.0.0.1:4567/', {
        fill_in: {
          username: 'tim',
          password: 'password',
          'csrf-token' => '${csrf-token}'
        }
      }
    end
  end
end.run(path: '/usr/share/jmeter/bin/')