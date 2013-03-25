$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 100 do # threads = RPS * <max response time ms> / 1000

    throughput_shaper 'increasing load test', [
      { :start_rps => 100, :end_rps => 100, :duration => 60 },
      { :start_rps => 200, :end_rps => 200, :duration => 60 },
      { :start_rps => 300, :end_rps => 300, :duration => 60 },
      { :start_rps => 400, :end_rps => 400, :duration => 60 },
      { :start_rps => 500, :end_rps => 500, :duration => 60 },
      { :start_rps => 600, :end_rps => 600, :duration => 60 }
    ]

    transaction 'Google Search' do
      visit 'Home Page', 'http://google.com/'
    end

  end
end.jmx
