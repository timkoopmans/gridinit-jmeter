module Gridinit
  module Jmeter

    class BeanShellPreProcessor
      attr_accessor :doc
      include Helper
      def initialize(script, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <BeanShellPreProcessor guiclass="TestBeanGUI" testclass="BeanShellPreProcessor" testname="BeanShell PreProcessor" enabled="true">
            <stringProp name="filename"></stringProp>
            <stringProp name="parameters"></stringProp>
            <boolProp name="resetInterpreter">false</boolProp>
            <stringProp name="script"><![CDATA[
#{script}
            ]]></stringProp>
          </BeanShellPreProcessor>
        EOF
        update params
      end
    end  

  end
end
