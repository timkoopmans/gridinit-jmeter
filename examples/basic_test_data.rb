$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

# this is an example using the Gridinit test data API

ENV['TESTDATA'] ='http://prod.gridinit.com:8080'

test do
  threads 1 do
    
    visit 'data', ENV['TESTDATA'] + '/ad48720631cd2f24/SRANDMEMBER' do extract 'url', '(http://.+?)"'; end

    visit 'Google Search', 'http://google.com?url=${url}'
  end
end.jmx