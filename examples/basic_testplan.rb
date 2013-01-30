$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

base_url = 'http://localhost:4567'
endpoint = 'localhost:3000'

test do

  cache :clear_each_iteration => true
  cookies
  
  threads 100 do

    random_timer 3000, 3000
  
    transaction 'First Visit', {:parent => true} do
      visit 'Home Page', "#{base_url}/" do
        extract 'csrf-token', "content='(.+?)' name='csrf-token'"
      end
    end

    transaction 'Login' do
      submit 'Submit Form', "#{base_url}/login", {
        :fill_in => {
          :username => 'tim',
          :password => 'password',
          'csrf-token' => '${csrf-token}'
        }
      }
      think_time 1000
    end

    transaction 'Check Mana' do
      visit 'Rails Camp' , "#{base_url}/magic" do
        assert "contains", "magic"
        assert "not-contains", "unicorns"
      end
    end

  end

end.jmx
# end.run(path: '/usr/share/jmeter/bin/')
# end.grid '4dy-zJLEIgpYkKe6p6JhSQ', { endpoint: endpoint }