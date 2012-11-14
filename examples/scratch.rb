require 'rubygems'
require 'nokogiri'
require 'docile'
require 'active_attr'

module Docile
  def dsl_eval(dsl, params={}, &block)
    block_context = eval("self", block.binding)
    proxy_context = FallbackContextProxy.new(dsl, block_context)
    begin
      block_context.instance_variables.each { |ivar| proxy_context.instance_variable_set(ivar, block_context.instance_variable_get(ivar)) }
      proxy_context.instance_eval(&block)
      # params.each {|k,v| dsl.send(k,v)}
    ensure
      block_context.instance_variables.each { |ivar| block_context.instance_variable_set(ivar, proxy_context.instance_variable_get(ivar)) }
    end
    dsl
  end
  module_function :dsl_eval
end

module Gridinit
  module Jmeter
    class ThreadGroup
      include ActiveAttr::Attributes
      include ActiveAttr::AttributeDefaults
      attribute :on_sample_error, :default => 'continue'
      
      # <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
      #   <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
      #   <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
      #     <boolProp name="LoopController.continue_forever">false</boolProp>
      #     <stringProp name="LoopController.loops">1</stringProp>
      #   </elementProp>
      #   <stringProp name="ThreadGroup.num_threads">1</stringProp>
      #   <stringProp name="ThreadGroup.ramp_time">1</stringProp>
      #   <longProp name="ThreadGroup.start_time">1352677419000</longProp>
      #   <longProp name="ThreadGroup.end_time">1352677419000</longProp>
      #   <boolProp name="ThreadGroup.scheduler">false</boolProp>
      #   <stringProp name="ThreadGroup.duration"></stringProp>
      #   <stringProp name="ThreadGroup.delay"></stringProp>
      # </ThreadGroup>


      def on_sample_error=(value)
        Gridinit::Jmeter::StringProp.new(name: "ThreadGroup.on_sample_error", value: value).to_xml
      end

      def to_xml
        ::Nokogiri::XML::Builder.new do |xml|
           xml.ThreadGroup_(guiclass: "ThreadGroupGui", testclass: "ThreadGroup", testname: "Thread Group", enabled: "true") {
            p self
           }
        end.to_xml.split("\n")[1..-1].join("\n")
      end

    end

    class StringProp
      include ActiveAttr::MassAssignment
      attr_accessor :name, :value

      def to_xml
        ::Nokogiri::XML::Builder.new do |xml|
           xml.stringProp(name: self.name) { xml.text self.value }
        end.to_xml.split("\n")[1..-1].join("\n")
      end
    end

    class BoolProp
      include ActiveAttr::MassAssignment
      attr_accessor :name, :value
    end
  end
end

def test(params={}, &block)
  p Docile.dsl_eval(Gridinit::Jmeter::ThreadGroup.new, params, &block).to_xml
end

test(on_sample_error: 'test') do
  
end





require 'rubygems'
require 'active_attr'

class Test
  include ActiveAttr::Attributes
  include ActiveAttr::AttributeDefaults
  attribute :on_sample_error, :default => 'continue'

  def on_sample_error=(value)
    self.on_sample_error=value
  end

end

t = Test.new
t.on_sample_error = 123


t[:on_sample_error]

properties = [
  {
    elementProp: {
      name: "ThreadGroup.main_controller",
      elementType: "LoopController",
      guiclass: "LoopControlPanel"
      elements
    }
  }
]


<stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
      #   <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
      #     <boolProp name="LoopController.continue_forever">false</boolProp>
      #     <stringProp name="LoopController.loops">1</stringProp>
      #   </elementProp>
      #   <stringProp name="ThreadGroup.num_threads">1</stringProp>
      #   <stringProp name="ThreadGroup.ramp_time">1</stringProp>
      #   <longProp name="ThreadGroup.start_time">1352677419000</longProp>
      #   <longProp name="ThreadGroup.end_time">1352677419000</longProp>
      #   <boolProp name="ThreadGroup.scheduler">false</boolProp>
      #   <stringProp name="ThreadGroup.duration"></stringProp>
      #   <stringProp name="ThreadGroup.delay"></stringProp>