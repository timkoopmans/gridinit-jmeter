module Gridinit
  module Jmeter

    class DSL
      def beanshell_timer(params={}, &block)
        node = Gridinit::Jmeter::BeanshellTimer.new(params)
        attach_node(node, &block)
      end
    end

    class BeanshellTimer
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellTimer guiclass="TestBeanGUI" testclass="BeanShellTimer" testname="#{name}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellTimer>)
        EOS
        update params
      end
    end

  end
end
