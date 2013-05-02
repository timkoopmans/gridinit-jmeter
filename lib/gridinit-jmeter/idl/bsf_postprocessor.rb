module Gridinit
  module Jmeter

    class DSL
      def bsf_postprocessor(params={}, &block)
        node = Gridinit::Jmeter::BsfPostprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class BsfPostprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFPostProcessor guiclass="TestBeanGUI" testclass="BSFPostProcessor" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFPostProcessor>)
        EOS
        update params
      end
    end

  end
end
