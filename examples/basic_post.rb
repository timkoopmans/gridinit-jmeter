$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do

  threads 1 do

    transaction 'Post with a Raw Body', {:parent => true} do
      post 'Home Page', 'http://google.com', {
        :raw_body => '{"name":"Big Poncho","price":10,"vendor_attendance_id":24,"product_id":1}'
      }
    end

  end

end.jmx