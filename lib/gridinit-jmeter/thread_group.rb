module Gridinit
  module Jmeter

    class ThreadGroup < Hashie::Trash
      attr_accessor :transactions
      property :quantity,                 :required => true, :default => 50, :transform_with => lambda { |v| v.to_i }

       # <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
       # <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
       #   <boolProp name="LoopController.continue_forever">false</boolProp>
       #   <stringProp name="LoopController.loops">1</stringProp>
       # </elementProp>
       # <stringProp name="ThreadGroup.num_threads">1</stringProp>
       # <stringProp name="ThreadGroup.ramp_time">1</stringProp>
       # <longProp name="ThreadGroup.start_time">1352677419000</longProp>
       # <longProp name="ThreadGroup.end_time">1352677419000</longProp>
       # <boolProp name="ThreadGroup.scheduler">false</boolProp>
       # <stringProp name="ThreadGroup.duration"></stringProp>
       # <stringProp name="ThreadGroup.delay"></stringProp>
      
      ##
      # DSL

      def transaction(params={}, &block)
        @transactions ||= []
        @transactions << Docile.dsl_eval(Gridinit::Jmeter::Transaction.new, params, &block)
      end

      

    end

  end
end