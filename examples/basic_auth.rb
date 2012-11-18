$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  auth url: '/', username: 'tim', password: 'secret', domain: 'altentee.com'
  threads 1 do
    transaction 'Google Search' do
      visit 'Home Page', 'http://google.com/'
    end
  end
end.jmx