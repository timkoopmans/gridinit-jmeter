module Gridinit
  module Jmeter

    class DSL
      def bsf_preprocessor(params={}, &block)
        node = Gridinit::Jmeter::BsfPreprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class BsfPreprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFPreProcessor guiclass="TestBeanGUI" testclass="BSFPreProcessor" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFPreProcessor>)
        EOS
        update params
      end
    end

  end
end
