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
        @root.at_xpath("//jmeterTestPlan/hashTree") << node.doc.children << hash_tree
        
        variables(
          :name     => 'testguid',
          :value    => '${__P(testguid,${__time(,)})}',
          :comments => 'The testguid variable is mandatory when running on the Grid.') {}
      end

      def variables(params={}, &block)
        node = Gridinit::Jmeter::UserDefinedVariable.new(params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def defaults(params={}, &block)
        node = Gridinit::Jmeter::RequestDefaults.new(params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def cookies(params={}, &block)
        node = Gridinit::Jmeter::CookieManager.new(params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def cache(params={}, &block)
        node = Gridinit::Jmeter::CacheManager.new(params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def header(params={}, &block)
        node = Gridinit::Jmeter::HeaderManager.new(params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def with_xhr(params={}, &block)
        node = Gridinit::Jmeter::HeaderManager.new(
          params.merge('X-Requested-With' => 'XMLHttpRequest')
        )
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def with_user_agent(device, params={}, &block)
        node = Gridinit::Jmeter::HeaderManager.new(
          params.merge('User-Agent' => Gridinit::Jmeter::UserAgent.new(device).string)
        )
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def auth(params={}, &block)
        node = Gridinit::Jmeter::AuthManager.new(params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def threads(num_threads=1, params={}, &block)
        node = Gridinit::Jmeter::ThreadGroup.new(num_threads, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def transaction(name="Transaction Contoller", params={}, &block)
        node = Gridinit::Jmeter::Transaction.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def exists(var, params={}, &block)
        params[:condition] = "'${#{var}}'.length > 0"
        node = Gridinit::Jmeter::IfController.new("if #{var}", params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def once(name="do once", params={}, &block)
        node = Gridinit::Jmeter::OnceOnly.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def throughput(name="throughput", percent=100.0, params={}, &block)
        node = Gridinit::Jmeter::Throughput.new(name, percent, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def If(name="If Controller", params={}, &block)
        node = Gridinit::Jmeter::IfController.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def Loop(loops=1, params={}, &block)
        node = Gridinit::Jmeter::LoopController.new(loops, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def counter(name="counter", params={}, &block)
        node = Gridinit::Jmeter::CounterConfig.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def bsh_pre(script, params={}, &block)
        node = Gridinit::Jmeter::BeanShellPreProcessor.new(script, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def visit(name="HTTP Request", url="", params={}, &block)
        params[:method] = 'GET'
        node = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :get, :visit

      def submit(name="HTTP Request", url="", params={}, &block)
        params[:method] = 'POST'
        node = Gridinit::Jmeter::HttpSampler.new(name, url, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :post, :submit

      def extract(*args, &block)
        node = case args.first
        when :regex
          Gridinit::Jmeter::RegexExtractor.new(*args.last(2))
        when :xpath
          Gridinit::Jmeter::XpathExtractor.new(*args.last(2))
        else
          Gridinit::Jmeter::RegexExtractor.new(*args)
        end
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :web_reg_save_param, :extract

      def random_timer(delay=0, range=0, &block)
        node = Gridinit::Jmeter::GaussianRandomTimer.new(delay, range)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :think_time, :random_timer

      def assert(match="contains", pattern="", params={}, &block)
        node = Gridinit::Jmeter::ResponseAssertion.new(match, pattern, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :web_reg_find, :assert

      def view_results_full_visualizer(name="View Results Tree", params={}, &block)
        node = Gridinit::Jmeter::ViewResultsFullVisualizer.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :view_results, :view_results_full_visualizer

      def table_visualizer(name="View Results in Table", params={}, &block)
        node = Gridinit::Jmeter::TableVisualizer.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def graph_visualizer(name="Graph Results", params={}, &block)
        node = Gridinit::Jmeter::GraphVisualizer.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def stat_visualizer(name="Stat Results", params={}, &block)
        node = Gridinit::Jmeter::StatVisualizer.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def simple_data_writer(name="Simple Data Writer", params={}, &block)
        node = Gridinit::Jmeter::SimpleDataWriter.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :log, :simple_data_writer

      def response_time_graph_visualizer(name="Reponse Time Graph", params={}, &block)
        node = Gridinit::Jmeter::ResponseTimeGraphVisualizer.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      alias_method :response_graph, :response_time_graph_visualizer

      def summary_report(name="Summary Report", params={}, &block)
        node = Gridinit::Jmeter::SummaryReport.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def ldap_ext(name="LDAPExtSampler", params={}, &block)
        node = Gridinit::Jmeter::LDAPExtSampler.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def gc_response_codes_per_second(name="jp@gc - Response Codes per Second", params={}, &block)
        node = Gridinit::Jmeter::GCResponseCodesPerSecond.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def gc_response_times_distribution(name="jp@gc - Response Times Distribution", params={}, &block)
        node = Gridinit::Jmeter::GCResponseTimesDistribution.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def gc_response_times_over_time(name="jp@gc - Response Times Over Time", params={}, &block)
        node = Gridinit::Jmeter::GCResponseTimesOverTime.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def gc_response_times_percentiles(name="jp@gc - Response Times Percentiles", params={}, &block)
        node = Gridinit::Jmeter::GCResponseTimesPercentiles.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def gc_transactions_per_second(name="jp@gc - Transactions per Second", params={}, &block)
        node = Gridinit::Jmeter::GCTransactionsPerSecond.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def gc_latencies_over_time(name="jp@gc - Response Latencies Over Time", params={}, &block)
        node = Gridinit::Jmeter::GCLatenciesOverTime.new(name, params)
        attach_to_last(node, caller)
        self.instance_exec(&block) if block
      end

      def out(params={})
        puts doc.to_xml(:indent => 2)
      end

      def jmx(params={})
        file(params)
        logger.info "JMX saved to: #{params[:file]}"
      end

      def run(params={})
        file(params)
        logger.warn "Test executing locally ..."
        cmd = "#{params[:path]}jmeter -n -t #{params[:file]} -j #{params[:log] ? params[:log] : 'jmeter.log' } -l #{params[:jtl] ? params[:jtl] : 'jmeter.jtl' }"
        logger.info cmd
        `#{cmd}`
        logger.info "Results at: #{params[:jtl] ? params[:jtl] : 'jmeter.jtl'}"
      end

      def grid(token, params={})
        RestClient.proxy = params[:proxy] if params[:proxy]
        begin
          file = Tempfile.new('jmeter')
          file.write(doc.to_xml(:indent => 2))
          file.rewind
          response = RestClient.post "http://#{params[:endpoint] ? params[:endpoint] : 'gridinit.com'}/api?token=#{token}&region=#{params[:region]}", 
          {
            :name => 'attachment', 
            :attachment => File.new("#{file.path}", 'rb'),
            :multipart => true,
            :content_type => 'application/octet-stream'
          }
          logger.info "Results at: #{JSON.parse(response)["results"]}" if response.code == 200
        rescue => e
          logger.fatal "There was an error: #{e.message}"
        end
      end
      
      private

      def hash_tree
        Nokogiri::XML::Node.new("hashTree", @root)
      end

      def attach_to_last(node, calling_method)
        xpath = xpath_from(calling_method)
        last_node  = @root.xpath(xpath).last
        last_node << node.doc.children << hash_tree
      end

      def xpath_from(calling_method)
        case calling_method.grep(/dsl/)[1][/`.*'/][1..-2]
        when 'threads'
          '//ThreadGroup/following-sibling::hashTree'
        when 'transaction'
          '//TransactionController/following-sibling::hashTree'
        when 'throughput'
          '//ThroughputController/following-sibling::hashTree'
        when 'once'
          '//OnceOnlyController/following-sibling::hashTree'
        when 'exists'
          '//IfController/following-sibling::hashTree'
        when 'Loop'
          '//LoopController/following-sibling::hashTree'
        when 'counter'
          '//CounterConfig/following-sibling::hashTree'
        when 'bsh_pre'
          '//BeanShellPreProcessor/following-sibling::hashTree'
        when 'visit'
          '//HTTPSamplerProxy/following-sibling::hashTree'
        when 'submit'
          '//HTTPSamplerProxy/following-sibling::hashTree'
        when 'post'
          '//HTTPSamplerProxy/following-sibling::hashTree'
        when 'extract'
          '//RegexExtractor/following-sibling::hashTree'
        when 'random_timer'
          '//GaussianRandomTimer/following-sibling::hashTree'
        else 
          '//TestPlan/following-sibling::hashTree'
        end
      end

      def file(params={})
        params[:file] ||= 'jmeter.jmx'
        File.open(params[:file], 'w') { |file| file.write(doc.to_xml(:indent => 2)) }
      end

      def doc
        Nokogiri::XML(@root.to_s,&:noblanks)
      end

      def logger
        @log ||= Logger.new(STDOUT)
        @log.level = Logger::DEBUG
        @log
      end

    end

  end
end

def test(&block)
  Gridinit.dsl_eval(Gridinit::Jmeter::DSL.new, &block)
end
