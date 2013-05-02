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

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="SimpleConfigGui" testclass="ConfigTestElement" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
