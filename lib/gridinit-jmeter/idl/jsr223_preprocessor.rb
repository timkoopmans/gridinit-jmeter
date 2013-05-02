module Gridinit
  module Jmeter

    class DSL
      def jsr223_preprocessor(params={}, &block)
        node = Gridinit::Jmeter::Jsr223Preprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class Jsr223Preprocessor
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223PreProcessor guiclass="TestBeanGUI" testclass="JSR223PreProcessor" testname="#{name}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223PreProcessor>)
        EOS
        update params
      end
    end

  end
end
