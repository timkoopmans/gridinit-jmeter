$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  header 'User-Agent' => 'Firefox'
  threads 1 do
    transaction 'Google Search' do
      visit 'Home Page', 'http://google.com/'
    end

    transaction 'Google Search via XHR' do
      visit 'Home Page', 'http://google.com/' do
        header 'X-Requested-With' => 'XMLHttpRequest'
      end
    end
  end
end.jmx