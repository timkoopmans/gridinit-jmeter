module Gridinit
  module Jmeter

    class DSL
      def jsr223_timer(params={}, &block)
        node = Gridinit::Jmeter::Jsr223Timer.new(params)
        attach_node(node, &block)
      end
    end

    class Jsr223Timer
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'Jsr223Timer'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Timer guiclass="TestBeanGUI" testclass="JSR223Timer" testname="#{params[:name]}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223Timer>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
