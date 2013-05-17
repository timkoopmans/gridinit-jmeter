module Gridinit
  module Jmeter

    class DSL
      def beanshell_postprocessor(params={}, &block)
        node = Gridinit::Jmeter::BeanshellPostprocessor.new(params)
        attach_node(node, &block)
      end
    end

    class BeanshellPostprocessor
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'BeanshellPostprocessor'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellPostProcessor guiclass="TestBeanGUI" testclass="BeanShellPostProcessor" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellPostProcessor>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
