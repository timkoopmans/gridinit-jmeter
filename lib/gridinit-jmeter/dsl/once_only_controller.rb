module Gridinit
  module Jmeter

    class DSL
      def once_only_controller(params, &block)
        node = Gridinit::Jmeter::OnceOnlyController.new(params)
        attach_node(node, &block)
      end
    end

    class OnceOnlyController
      attr_accessor :doc
      include Helper

      def initialize(params={})
        params[:name] ||= 'OnceOnlyController'
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<OnceOnlyController guiclass="OnceOnlyControllerGui" testclass="OnceOnlyController" testname="#{params[:name]}" enabled="true"/>)
        EOS
        update params
        update_at_xpath params if params[:update_at_xpath]
      end
    end

  end
end
