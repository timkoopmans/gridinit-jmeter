$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 1, { :loops => 10 } do
    visit 'Google Search', 'http://google.com'
  end
  
  #
  # You need jmeter-plugins at Google code
  #   http://code.google.com/p/jmeter-plugins
  #
  gc_latencies_over_time 'Response Latencies Over Time'
  gc_response_codes_per_second 'Response Codes per Second'
  gc_response_times_distribution 'Response Times Distribution'
  gc_response_times_over_time 'Response Times Over Time'
  gc_response_times_percentiles 'Response Times Percentiles'
  gc_transactions_per_second 'Transactions per Second'

end.jmx
