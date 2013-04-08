module Gridinit
  module Jmeter

    class RandomVariableConfig
      attr_accessor :doc
      include Helper
      def initialize(name, min, max, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
        <RandomVariableConfig guiclass="TestBeanGUI" testclass="RandomVariableConfig" testname="#{name}" enabled="#{enabled(params)}">
          <stringProp name="maximumValue">#{max}</stringProp>
          <stringProp name="minimumValue">#{min}</stringProp>
          <stringProp name="outputFormat"></stringProp>
          <boolProp name="perThread">false</boolProp>
          <stringProp name="randomSeed"></stringProp>
          <stringProp name="variableName">#{name}</stringProp>
        </RandomVariableConfig>

        EOF
        update params
      end
    end  

  end
end
