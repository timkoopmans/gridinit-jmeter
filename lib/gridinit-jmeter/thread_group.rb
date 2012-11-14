module Gridinit
  module Jmeter

    class ThreadGroup < Hashie::Trash
      attr_accessor :associations

      # <stringProp name="ThreadGroup.on_sample_error">continue</stringProp> 
      # <stringProp name="ThreadGroup.num_threads">1</stringProp>
      # <stringProp name="ThreadGroup.ramp_time">1</stringProp>
      # <longProp name="ThreadGroup.start_time">1352677419000</longProp>
      # <longProp name="ThreadGroup.end_time">  1352677419000</longProp>
      # <boolProp name="ThreadGroup.scheduler">false</boolProp>
      # <stringProp name="ThreadGroup.duration"></stringProp>
      # <stringProp name="ThreadGroup.delay"></stringProp>
      property :on_sample_error,          :required => false, :default => 'continue'
      property :num_threads,              :required => false, :default => 1, :transform_with => lambda { |v| v.to_s }
      property :ramp_time,                :required => false, :default => 1, :transform_with => lambda { |v| v.to_s }
      property :start_time,               :required => false, :default => Time.now.to_i * 1000
      property :end_time,                 :required => false, :default => Time.now.to_i * 1000
      property :scheduler,                :required => false, :default => false
      property :duration,                 :required => false, :transform_with => lambda { |v| v.to_s }
      property :delay,                    :required => false, :transform_with => lambda { |v| v.to_s }

      property :continue_forever,         :required => false, :default => false
      property :loops,                    :required => false, :default => 1, :transform_with => lambda { |v| v.to_s }
 
      def initialize
        @associations ||= []
      end

      def to_xml
        p self.keys
      end

      # DSL      
      def transaction(params={}, &block)
        @associations << Docile.dsl_eval(Gridinit::Jmeter::Transaction.new, params, &block)
      end
    end

    class LoopController < Hashie::Trash
      # <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
      #   <boolProp name="LoopController.continue_forever">false</boolProp>
      #   <stringProp name="LoopController.loops">1</stringProp>
      # </elementProp>
      property :continue_forever,         :required => false, :default => false
      property :loops,                    :required => false, :default => 1, :transform_with => lambda { |v| v.to_s }
    end

  end
end