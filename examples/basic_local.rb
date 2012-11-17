$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

# To execute the test locally, call the method .local 
# at the end of your test plan definition.

test do
  random_timer delay: 500, range: 500
  threads 10, {loops: 10} do
    transaction 'Dummy Scenario' do
      visit 'Altentee', 'http://127.0.0.1:9200/'
    end
  end
end.local