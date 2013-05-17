$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads count: 1 do
    visit name: 'Home Page', url: 'http://google.com/'
  end
end.grid('4dy-zJLEIgpYkKe6p6JhSQ', {:region => 'ap_southeast_1'})
