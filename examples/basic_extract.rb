$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads count: 100 do
    visit name: 'Home', url: 'http://altentee.com' do
      extract regex: "content='(.+?)' name='csrf-token'", name: 'csrf-token'
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
