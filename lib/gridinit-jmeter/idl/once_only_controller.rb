module Gridinit
  module Jmeter

    class DSL
      def once_only_controller(params={}, &block)
        node = Gridinit::Jmeter::OnceOnlyController.new(params)
        attach_node(node, &block)
      end
    end

    class OnceOnlyController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<OnceOnlyController guiclass="OnceOnlyControllerGui" testclass="OnceOnlyController" testname="#{name}" enabled="true"/>)
        EOS
        update params
      end
    end

  end
end
