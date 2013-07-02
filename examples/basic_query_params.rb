$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads count: 10 do
    visit name: 'Google Search', url: 'http://google.com/?hl=en&tbo=d&sclient=psy-ab&q=gridinit&oq=gridinit'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
