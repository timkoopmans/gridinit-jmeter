module Gridinit
  module Jmeter

    class Throughput
      attr_accessor :doc
      include Helper
      def initialize(name, percent, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <ThroughputController guiclass="ThroughputControllerGui" testclass="ThroughputController" testname="#{percent.to_i}%_#{name}" enabled="true">
          <intProp name="ThroughputController.style">1</intProp>
          <boolProp name="ThroughputController.perThread">false</boolProp>
          <intProp name="ThroughputController.maxThroughput">1</intProp>
          <FloatProperty>
            <name>ThroughputController.percentThroughput</name>
            <value>#{percent.to_f}</value>
            <savedValue>0.0</savedValue>
          </FloatProperty>
        </ThroughputController>
        EOF
        update params
      end
    end  

  end
end

