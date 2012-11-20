$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 10 do
    visit 'Google Search', 'http://google.com'
  end
end.grid('4dy-zJLEIgpYkKe6p6JhSQ', {proxy: 'http://corporateproxy:8080'})