module Gridinit
  module Jmeter

    class DSL
      def regex_user_parameters(params={}, &block)
        node = Gridinit::Jmeter::RegexUserParameters.new(params)
        attach_node(node, &block)
      end
    end

    class RegexUserParameters
      attr_accessor :doc
      include Helper

      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<RegExUserParameters guiclass="RegExUserParametersGui" testclass="RegExUserParameters" testname="#{name}" enabled="true">
  <stringProp name="RegExUserParameters.regex_ref_name"/>
  <stringProp name="RegExUserParameters.param_names_gr_nr"/>
  <stringProp name="RegExUserParameters.param_values_gr_nr"/>
</RegExUserParameters>)
        EOS
        update params
      end
    end

  end
end
