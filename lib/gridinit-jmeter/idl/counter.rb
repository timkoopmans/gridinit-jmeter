module Gridinit
  module Jmeter

    class DSL
      def counter(params={}, &block)
        node = Gridinit::Jmeter::Counter.new(params)
        attach_node(node, &block)
      end
    end

    class Counter
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CounterConfig guiclass="CounterConfigGui" testclass="CounterConfig" testname="#{name}" enabled="true">
  <stringProp name="CounterConfig.start"/>
  <stringProp name="CounterConfig.end"/>
  <stringProp name="CounterConfig.incr"/>
  <stringProp name="CounterConfig.name"/>
  <stringProp name="CounterConfig.format"/>
  <boolProp name="CounterConfig.per_user">false</boolProp>
</CounterConfig>)
        EOS
        update params
      end
    end

  end
end
