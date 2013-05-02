module Gridinit
  module Jmeter

    class DSL
      def runtime_controller(params={}, &block)
        node = Gridinit::Jmeter::RuntimeController.new(params)
        attach_node(node, &block)
      end
    end

    class RuntimeController
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RunTime guiclass="RunTimeGui" testclass="RunTime" testname="#{name}" enabled="true">
  <stringProp name="RunTime.seconds">1</stringProp>
</RunTime>)
        EOS
        update params
      end
    end

  end
end
