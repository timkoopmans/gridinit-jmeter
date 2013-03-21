$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 1 do
    visit 'Google Search', 'http://google.com'
  end

  simple_data_writer 'errors', { filename: '/var/log/gridnode/stderr.log', error_logging: true }

  # also aliased as log
  log  'success', { filename: '/var/log/gridnode/successful.log' }
  
end.jmx