module Gridinit
  module Jmeter

    class ThreadGroup
      attr_accessor :doc
      def initialize(num_threads, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
            <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
            <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
              <boolProp name="LoopController.continue_forever">false</boolProp>
              <stringProp name="LoopController.loops">1</stringProp>
            </elementProp>
            <stringProp name="ThreadGroup.num_threads">#{num_threads}</stringProp>
            <stringProp name="ThreadGroup.ramp_time">1</stringProp>
            <longProp name="ThreadGroup.start_time">1352677419000</longProp>
            <longProp name="ThreadGroup.end_time">1352677419000</longProp>
            <boolProp name="ThreadGroup.scheduler">false</boolProp>
            <stringProp name="ThreadGroup.duration"></stringProp>
            <stringProp name="ThreadGroup.delay"></stringProp>
          </ThreadGroup>
        EOF
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end  

  end
end