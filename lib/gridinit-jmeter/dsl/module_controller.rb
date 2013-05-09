module Gridinit
  module Jmeter

    class DSL
      def module_controller(params={}, &block)
        node = Gridinit::Jmeter::ModuleController.new(params)
        attach_node(node, &block)
      end
    end

    class ModuleController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ModuleController guiclass="ModuleControllerGui" testclass="ModuleController" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
