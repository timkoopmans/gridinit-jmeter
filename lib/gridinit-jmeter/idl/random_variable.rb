module Gridinit
  module Jmeter

    class DSL
      def random_variable(params={}, &block)
        node = Gridinit::Jmeter::RandomVariable.new(params)
        attach_node(node, &block)
      end
    end

    class RandomVariable
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RandomVariableConfig guiclass="TestBeanGUI" testclass="RandomVariableConfig" testname="#{name}" enabled="true">
  <stringProp name="maximumValue"/>
  <stringProp name="minimumValue">1</stringProp>
  <stringProp name="outputFormat"/>
  <boolProp name="perThread">false</boolProp>
  <stringProp name="randomSeed"/>
  <stringProp name="variableName"/>
</RandomVariableConfig>)
        EOS
        update params
      end
    end

  end
end
