module Gridinit
  module Jmeter

    class DSL
      def jsr223_postprocessor(params={}, &block)
        node = Gridinit::Jmeter::Jsr223Postprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class Jsr223Postprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223PostProcessor guiclass="TestBeanGUI" testclass="JSR223PostProcessor" testname="#{name}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223PostProcessor>)
        EOS
        update params
      end
    end

  end
end
