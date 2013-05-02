module Gridinit
  module Jmeter

    class DSL
      def bsf_timer(params={}, &block)
        node = Gridinit::Jmeter::BsfTimer.new(params)
        attach_node(node, &block)
      end
    end

    class BsfTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFTimer guiclass="TestBeanGUI" testclass="BSFTimer" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFTimer>)
        EOS
        update params
      end
    end

  end
end
