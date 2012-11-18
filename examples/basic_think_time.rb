$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 100 do
    think_time 5000,5000
    transaction 'Google Search' do
      visit 'Home Page', 'http://google.com/'
      random_timer 3000
    end
  end
end.jmx