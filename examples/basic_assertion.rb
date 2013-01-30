$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 2 do
    transaction 'Assertions' do
      visit 'Altentee', 'http://altentee.com/' do
        assert "contains", "We test, tune and secure your site"
        assert "not-contains", "Something in frames", {:scope => 'all'}
      end
    end
  end
end.jmx