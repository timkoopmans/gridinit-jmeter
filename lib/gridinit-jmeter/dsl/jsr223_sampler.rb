module Gridinit
  module Jmeter

    class DSL
      def jsr223_sampler(params={}, &block)
        node = Gridinit::Jmeter::Jsr223Sampler.new(params)
        attach_node(node, &block)
      end
    end

    class Jsr223Sampler
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Sampler guiclass="TestBeanGUI" testclass="JSR223Sampler" testname="#{name}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223Sampler>)
        EOS
        update params
      end
    end

  end
end
