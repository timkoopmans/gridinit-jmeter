module Gridinit
  module Jmeter

    class DSL
      def jsr223_assertion(params={}, &block)
        node = Gridinit::Jmeter::Jsr223Assertion.new(params)
        attach_node(node, &block)
      end
    end

    class Jsr223Assertion
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Assertion guiclass="TestBeanGUI" testclass="JSR223Assertion" testname="#{name}" enabled="true">
  <stringProp name="scriptLanguage"/>
  <stringProp name="parameters"/>
  <stringProp name="filename"/>
  <stringProp name="cacheKey"/>
  <stringProp name="script"/>
</JSR223Assertion>)
        EOS
        update params
      end
    end

  end
end
