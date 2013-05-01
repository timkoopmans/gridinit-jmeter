module Gridinit

  def dsl_eval(dsl, &block)
    block_context = eval("self", block.binding)
    proxy_context = Gridinit::Jmeter::FallbackContextProxy.new(dsl, block_context)
    begin
      block_context.instance_variables.each { |ivar| proxy_context.instance_variable_set(ivar, block_context.instance_variable_get(ivar)) }
      proxy_context.instance_eval(&block)
    ensure
      block_context.instance_variables.each { |ivar| block_context.instance_variable_set(ivar, proxy_context.instance_variable_get(ivar)) }
    end
    dsl
  end

  module_function :dsl_eval

  module Jmeter

    class DSL
      attr_accessor :root

      def initialize
        @root = Nokogiri::XML(<<-EOF.strip_heredoc)
          <?xml version="1.0" encoding="UTF-8"?>
          <jmeterTestPlan version="1.2" properties="2.1">
          <hashTree>
          </hashTree>
          </jmeterTestPlan>
        EOF
        node = Gridinit::Jmeter::TestPlan.new


        @current_node = @root.at_xpath("//jmeterTestPlan/hashTree")
        @current_node = attach_to_last(node)

        variables(
          :name     => 'testguid',
          :value    => '${__P(testguid,${__time(,)})}',
          :comments => 'The testguid variable is mandatory when running on the Grid.') {}
      end

      def variables(params={}, &block)
        node = Gridinit::Jmeter::UserDefinedVariable.new(params)
        attach_node(node, &block)
      end

      def defaults(params={}, &block)
        node = Gridinit::Jmeter::RequestDefaults.new(params)
        attach_node(node, &block)
      end

      def cookies(params={}, &block)
        node = Gridinit::Jmeter::CookieManager.new(params)
        attach_node(node, &block)
      end

      def cache(params={}, &block)
        node = Gridinit::Jmeter::CacheManager.new(params)
        attach_node(node, &block)
      end

      def header(params={}, &block)
        node = Gridinit::Jmeter::HeaderManager.new(params)
        attach_node(node, &block)
      end

      def with_xhr(params={}, &block)
        node = Gridinit::Jmeter::HeaderManager.new(
          params.merge('X-Requested-With' => 'XMLHttpRequest')
        )
        attach_node(node, &block)
      end

      def with_user_agent(device, params={}, &block)
        node = Gridinit::Jmeter::HeaderManager.new(
          params.merge('User-Agent' => Gridinit::Jmeter::UserAgent.new(device).string)
        )
        attach_node(node, &block)
      end

      def auth(params={}, &block)
        node = Gridinit::Jmeter::AuthManager.new(params)
        attach_node(node, &block)
      end

      def threads(num_threads=1, params={}, &block)
        node = Gridinit::Jmeter::ThreadGroup.new(num_threads, params)
        attach_node(node, &block)
      end

      def transaction(name="Transaction Contoller", params={}, &block)
        node = Gridinit::Jmeter::Transaction.new(name, params)
        attach_node(node, &block)
      end

      def exists(var, params={}, &block)
        params[:condition] = "'${#{var}}'.length > 0"
        node               = Gridinit::Jmeter::IfController.new("if #{var}", params)
        attach_node(node, &block)
      end

      def once(name="do once", params={}, &block)
        node = Gridinit::Jmeter::OnceOnly.new(name, params)
        attach_node(node, &block)
      end

      def throughput(name="throughput", percent=100.0, params={}, &block)
        node = Gridinit::Jmeter::Throughput.new(name, percent, params)
        attach_node(node, &block)
      end

      def If(name="If Controller", condition="", params={}, &block)
        node = Gridinit::Jmeter::IfController.new(name, condition, params)
        attach_node(node, &block)
      end

      def Loop(loops=1, params={}, &block)
        node = Gridinit::Jmeter::LoopController.new(loops, params)
        attach_node(node, &block)
      end

      def Switch(name, switch_value, params={}, &block)
        node = Gridinit::Jmeter::SwitchController.new(name, switch_value, params)
        attach_node(node, &block)
      end

      def While(condition, params={}, &block)
        node = Gridinit::Jmeter::WhileController.new(condition, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def counter(name="counter", params={}, &block)
        node = Gridinit::Jmeter::CounterConfig.new(name, params)
        attach_node(node, &block)
      end

      def random_variable(name, min, max, params={}, &block)
        node = Gridinit::Jmeter::RandomVariableConfig.new(name, min, max, params)
        attach_node(node, &block)
      end

      def random_order(name='Random Order Controller', params={}, &block)
        node = Gridinit::Jmeter::RandomOrderController.new(name, params)
        attach_node(node, &block)
      end

      def interleave(name='Interleave Controller', params={}, &block)
        node = Gridinit::Jmeter::InterleaveController.new(name, params)
        attach_node(node, &block)
      end

      def simple(name='Simple Controller', params={}, &block)
        node = Gridinit::Jmeter::SimpleController.new(name, params)
        attach_node(node, &block)
      end

      def bsh_pre(script, params={}, &block)
        node = Gridinit::Jmeter::BeanShellPreProcessor.new(script, params)
        attach_node(node, &block)
      end

      def visit(name="HTTP Request", url="", params={}, &block)
        params[:method] ||= 'GET'
        node = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        node            = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        attach_node(node, &block)
      end

      alias_method :get, :visit

      def submit(name="HTTP Request", url="", params={}, &block)
        params[:method] ||= 'POST'
        node            = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        attach_node(node, &block)
      end

      alias_method :post, :submit

      def delete(name="HTTP Request", url="", params={}, &block)
        params[:method] ||= 'DELETE'
        node            = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        attach_node(node, &block)
      end

      def put(name="HTTP Request", url="", params={}, &block)
        params[:method] ||= 'PUT'
        node            = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        attach_node(node, &block)
      end

      def extract(*args, &block)
        node = case args.first
                 when :regex
                   Gridinit::Jmeter::RegexExtractor.new(*args[1..-1])
                 when :xpath
                   Gridinit::Jmeter::XpathExtractor.new(*args[1..-1])
                 else
                   Gridinit::Jmeter::RegexExtractor.new(*args)
               end
        attach_node(node, &block)
      end

      alias_method :web_reg_save_param, :extract

      def random_timer(delay=0, range=0, &block)
        node = Gridinit::Jmeter::GaussianRandomTimer.new(delay, range)
        attach_node(node, &block)
      end

      alias_method :think_time, :random_timer

      def assert(match="contains", pattern="", params={}, &block)
        node = Gridinit::Jmeter::ResponseAssertion.new(match, pattern, params)
        attach_node(node, &block)
      end

      alias_method :web_reg_find, :assert

      def view_results_full_visualizer(name="View Results Tree", params={}, &block)
        node = Gridinit::Jmeter::ViewResultsFullVisualizer.new(name, params)
        attach_node(node, &block)
      end

      alias_method :view_results, :view_results_full_visualizer

      def table_visualizer(name="View Results in Table", params={}, &block)
        node = Gridinit::Jmeter::TableVisualizer.new(name, params)
        attach_node(node, &block)
      end

      def graph_visualizer(name="Graph Results", params={}, &block)
        node = Gridinit::Jmeter::GraphVisualizer.new(name, params)
        attach_node(node, &block)
      end

      def stat_visualizer(name="Stat Results", params={}, &block)
        node = Gridinit::Jmeter::StatVisualizer.new(name, params)
        attach_node(node, &block)
      end

      def simple_data_writer(name="Simple Data Writer", params={}, &block)
        node = Gridinit::Jmeter::SimpleDataWriter.new(name, params)
        attach_node(node, &block)
      end

      alias_method :log, :simple_data_writer

      def response_time_graph_visualizer(name="Reponse Time Graph", params={}, &block)
        node = Gridinit::Jmeter::ResponseTimeGraphVisualizer.new(name, params)
        attach_node(node, &block)
      end

      alias_method :response_graph, :response_time_graph_visualizer

      def summary_report(name="Summary Report", params={}, &block)
        node = Gridinit::Jmeter::SummaryReport.new(name, params)
        attach_node(node, &block)
      end

      def aggregate_report(name="Aggregate Report", params={}, &block)
        node = Gridinit::Jmeter::AggregateReport.new(name, params)
        attach_node(node, &block)
      end

      def ldap_ext(name="LDAPExtSampler", params={}, &block)
        node = Gridinit::Jmeter::LDAPExtSampler.new(name, params)
        attach_node(node, &block)
      end

      def gc_response_codes_per_second(name="jp@gc - Response Codes per Second", params={}, &block)
        node = Gridinit::Jmeter::GCResponseCodesPerSecond.new(name, params)
        attach_node(node, &block)
      end

      def gc_response_times_distribution(name="jp@gc - Response Times Distribution", params={}, &block)
        node = Gridinit::Jmeter::GCResponseTimesDistribution.new(name, params)
        attach_node(node, &block)
      end

      def gc_response_times_over_time(name="jp@gc - Response Times Over Time", params={}, &block)
        node = Gridinit::Jmeter::GCResponseTimesOverTime.new(name, params)
        attach_node(node, &block)
      end

      def gc_response_times_percentiles(name="jp@gc - Response Times Percentiles", params={}, &block)
        node = Gridinit::Jmeter::GCResponseTimesPercentiles.new(name, params)
        attach_node(node, &block)
      end

      def gc_transactions_per_second(name="jp@gc - Transactions per Second", params={}, &block)
        node = Gridinit::Jmeter::GCTransactionsPerSecond.new(name, params)
        attach_node(node, &block)
      end

      def gc_latencies_over_time(name="jp@gc - Response Latencies Over Time", params={}, &block)
        node = Gridinit::Jmeter::GCLatenciesOverTime.new(name, params)
        attach_node(node, &block)
      end

      def gc_console_status_logger(name="jp@gc - Console Status Logger", params={}, &block)
        node = Gridinit::Jmeter::GCConsoleStatusLogger.new(name, params)
        attach_node(node, &block)
      end

      alias_method :console, :gc_console_status_logger

      def throughput_shaper(name="jp@gc - Throughput Shaping Timer", steps=[], params={}, &block)
        node = Gridinit::Jmeter::ThroughputShapingTimer.new(name, steps)
        attach_node(node, &block)
      end

      alias_method :shaper, :throughput_shaper

      def out(params={})
        puts doc.to_xml(:indent => 2)
      end

      def jmx(params={})
        file(params)
        logger.info "Test plan saved to: #{params[:file]}"
      end

      def to_xml
        doc.to_xml(:indent => 2)
      end

      def to_doc
        doc.clone
      end

      def run(params={})
        file(params)
        logger.warn "Test executing locally ..."
        cmd = "#{params[:path]}jmeter #{"-n" unless params[:gui] } -t #{params[:file]} -j #{params[:log] ? params[:log] : 'jmeter.log' } -l #{params[:jtl] ? params[:jtl] : 'jmeter.jtl' }"
        logger.debug cmd if params[:debug]
        Open3.popen2e("#{cmd} -q #{File.dirname(__FILE__)}/helpers/jmeter.properties") do |stdin, stdout_err, wait_thr|
          while line = stdout_err.gets
            logger.debug line.chomp if params[:debug]
          end

          exit_status = wait_thr.value
          unless exit_status.success?
            abort "FAILED !!! #{cmd}"
          end
        end
        logger.info "Local Results at: #{params[:jtl] ? params[:jtl] : 'jmeter.jtl'}"
      end

      def grid(token, params={})
        if params[:region] == 'local'
          logger.info "Starting test ..."
          params[:started] = Time.now
          run params
          params[:completed] = Time.now
          logger.info "Completed test ..."
          logger.debug "Uploading results ..." if params[:debug]
        end
        RestClient.proxy = params[:proxy] if params[:proxy]
        begin
          file = Tempfile.new('jmeter')
          file.write(doc.to_xml(:indent => 2))
          file.rewind
          response = RestClient.post "http://#{params[:endpoint] ? params[:endpoint] : 'gridinit.com'}/api?token=#{token}&region=#{params[:region]}",
          {
            :name => 'attachment',
            :attachment => File.new("#{file.path}", 'rb'),
            :results => (File.new("#{params[:jtl] ? params[:jtl] : 'jmeter.jtl'}", 'rb') if params[:region] == 'local'),
            :multipart => true,
            :content_type => 'application/octet-stream',
            :started => params[:started],
            :completed => params[:completed]
          }
          logger.info "Grid Results at: #{JSON.parse(response)["results"]}" if response.code == 200
        rescue => e
          logger.fatal "There was an error: #{e.message}"
        end
      end

      private

      def hash_tree
        Nokogiri::XML::Node.new("hashTree", @root)
      end

      def attach_to_last(node)
        ht        = hash_tree
        last_node = @current_node
        last_node << node.doc.children << ht
        ht
      end

      def attach_node(node, &block)
        ht            = attach_to_last(node)
        previous      = @current_node
        @current_node = ht
        self.instance_exec(&block) if block
        @current_node = previous
      end

      def file(params={})
        params[:file] ||= 'jmeter.jmx'
        File.open(params[:file], 'w') { |file| file.write(doc.to_xml(:indent => 2)) }
      end

      def doc
        Nokogiri::XML(@root.to_s, &:noblanks)
      end

      def logger
        @log       ||= Logger.new(STDOUT)
        @log.level = Logger::DEBUG
        @log
      end

    end

  end
end

def test(&block)
  Gridinit.dsl_eval(Gridinit::Jmeter::DSL.new, &block)
end
