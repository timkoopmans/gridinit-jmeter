$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

# To execute the test on Gridinit, call the method .grid
# at the end of your test plan definition. You also need to
# specify the API token and optional endpoint for the Grid.

test do
  random_timer delay: 500, range: 500
  threads num_threads: 100, loops: 10 do
    transaction 'Dummy Scenario' do
      visit 'Altentee', 'http://127.0.0.1:9200/'
    end
  end
end.grid('abcd1234', {endpoint: '127.0.0.1:3000'})