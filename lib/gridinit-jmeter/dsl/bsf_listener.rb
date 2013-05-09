module Gridinit
  module Jmeter

    class DSL
      def bsf_listener(params={}, &block)
        node = Gridinit::Jmeter::BsfListener.new(params)
        attach_node(node, &block)
      end
    end

    class BsfListener
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFListener guiclass="TestBeanGUI" testclass="BSFListener" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFListener>)
        EOS
        update params
      end
    end

  end
end
