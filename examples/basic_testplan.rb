$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test(comments: 'Example test plan') do
  threads(quantity: 1000) do
    transaction do
      visit(url: 'http://127.0.0.1') {}
    end
  end

end