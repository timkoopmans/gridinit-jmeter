module Gridinit
  module Jmeter

    class ThreadGroup
      attr_accessor :doc
      include Helper
      def initialize(num_threads, params={})
        params[:ramp_time] ||= num_threads/2
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
            <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
            <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
              <boolProp name="LoopController.continue_forever">false</boolProp>
              <stringProp name="LoopController.loops">1</stringProp>
            </elementProp>
            <stringProp name="ThreadGroup.num_threads">#{num_threads}</stringProp>
            <stringProp name="ThreadGroup.ramp_time">#{params[:ramp_time]}</stringProp>
            <longProp name="ThreadGroup.start_time">#{Time.now.to_i * 1000}</longProp>
            <longProp name="ThreadGroup.end_time">#{Time.now.to_i * 1000}</longProp>
            <boolProp name="ThreadGroup.scheduler">true</boolProp>
            <stringProp name="ThreadGroup.duration"></stringProp>
            <stringProp name="ThreadGroup.delay"></stringProp>
          </ThreadGroup>
        EOF
        update params
      end
    end  

  end
end
