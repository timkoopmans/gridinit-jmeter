module Gridinit
  module Jmeter

    class DSL
      def simple_config_element(params={}, &block)
        node = Gridinit::Jmeter::SimpleConfigElement.new(params)
        attach_node(node, &block)
      end
    end

    class SimpleConfigElement
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'SimpleConfigElement'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="SimpleConfigGui" testclass="ConfigTestElement" testname="#{params[:name]}" enabled="true"/>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
