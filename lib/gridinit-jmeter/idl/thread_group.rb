module Gridinit
  module Jmeter

    class DSL
      def thread_group(params={}, &block)
        node = Gridinit::Jmeter::ThreadGroup.new(params)
        attach_node(node, &block)
      end
    end

    class ThreadGroup
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="#{name}" enabled="true">
  <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
  <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="#{name}" enabled="true">
    <boolProp name="LoopController.continue_forever">false</boolProp>
    <stringProp name="LoopController.loops">1</stringProp>
  </elementProp>
  <stringProp name="ThreadGroup.num_threads">1</stringProp>
  <stringProp name="ThreadGroup.ramp_time">1</stringProp>
  <longProp name="ThreadGroup.start_time">1366415241000</longProp>
  <longProp name="ThreadGroup.end_time">1366415241000</longProp>
  <boolProp name="ThreadGroup.scheduler">false</boolProp>
  <stringProp name="ThreadGroup.duration"/>
  <stringProp name="ThreadGroup.delay"/>
</ThreadGroup>)
        EOS
        update params
      end
    end

  end
end
