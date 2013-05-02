module Gridinit
  module Jmeter

    class DSL
      def jsr223_listener(params={}, &block)
        node = Gridinit::Jmeter::Jsr223Listener.new(params)
        attach_node(node, &block)
      end
    end

    class Jsr223Listener
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Listener guiclass="TestBeanGUI" testclass="JSR223Listener" testname="#{name}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223Listener>)
        EOS
        update params
      end
    end

  end
end
