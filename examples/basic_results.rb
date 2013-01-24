$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 1, { loops: 10 } do
    visit 'Google Search', 'http://google.com'
  end
  
  #
  # About response_graph
  #
  # Too few samples in this example.
  # Please change interval(ms) by hand when you display results.
  #
  table_visualizer 'Table Visualizer'
  graph_visualizer 'Graph Visualizer'
  stat_visualizer  'Stat Visualizer'
  response_graph   'response_graph'
  summary_report   'Summary Report'
  view_results     'View Results Tree'

end.jmx
