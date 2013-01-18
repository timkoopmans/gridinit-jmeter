$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  think_time 100
  threads 100, {ramp_time: 10, loops: 10} do
    transaction 'Home Page' do
      visit 'Altentee', 'http://127.0.0.1:9200/'
    end
  end
end.grid('4dy-zJLEIgpYkKe6p6JhSQ', {endpoint: '127.0.0.1:3000', region: 'ap_southeast_1'})