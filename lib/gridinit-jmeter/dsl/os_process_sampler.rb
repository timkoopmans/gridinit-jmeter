module Gridinit
  module Jmeter

    class DSL
      def os_process_sampler(params={}, &block)
        node = Gridinit::Jmeter::OsProcessSampler.new(params)
        attach_node(node, &block)
      end
    end

    class OsProcessSampler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SystemSampler guiclass="SystemSamplerGui" testclass="SystemSampler" testname="#{name}" enabled="true">
  <boolProp name="SystemSampler.checkReturnCode">false</boolProp>
  <stringProp name="SystemSampler.expectedReturnCode">0</stringProp>
  <stringProp name="SystemSampler.command"/>
  <elementProp name="SystemSampler.arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <elementProp name="SystemSampler.environment" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{name}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="SystemSampler.directory"/>
</SystemSampler>)
        EOS
        update params
      end
    end

  end
end
