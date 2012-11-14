$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test(comments: 'Example test plan') do
  threads(num_threads: 1000, loops: 100) do
    transaction do
      visit(url: 'http://127.0.0.1') {}
    end
  end

end