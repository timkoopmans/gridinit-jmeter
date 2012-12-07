module Gridinit
  module Jmeter

    class HttpSampler
      attr_accessor :doc
      def initialize(name, url, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="#{name}" enabled="true">
            <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
              <collectionProp name="Arguments.arguments"/>
            </elementProp>
            <stringProp name="HTTPSampler.domain"></stringProp>
            <stringProp name="HTTPSampler.port"></stringProp>
            <stringProp name="HTTPSampler.connect_timeout"></stringProp>
            <stringProp name="HTTPSampler.response_timeout"></stringProp>
            <stringProp name="HTTPSampler.protocol"></stringProp>
            <stringProp name="HTTPSampler.contentEncoding"></stringProp>
            <stringProp name="HTTPSampler.path">/</stringProp>
            <stringProp name="HTTPSampler.method">GET</stringProp>
            <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
            <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
            <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
            <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
            <boolProp name="HTTPSampler.monitor">false</boolProp>
            <boolProp name="HTTPSampler.image_parser">true</boolProp>
            <boolProp name="HTTPSampler.concurrentDwn">true</boolProp>
            <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
          </HTTPSamplerProxy>
        EOF
        parse_url(url, params) unless url.empty?
        fill_in(params) if params[:fill_in]
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end

      def parse_uri(url)
        URI.parse(url).scheme.nil? ? URI.parse("http://#{url}") : URI.parse(url)   
      end

      def parse_url(url, params)
        if url[0] == '$'
          params[:path] = url # special case for named expressions
        else 
          uri               = parse_uri(url)
          params[:protocol] = uri.scheme
          params[:domain]   = uri.host
          params[:port]     = uri.port
          params[:path]     = uri.path
        end
      end

      def fill_in(params)
        params[:fill_in].each do |name, value|
          @doc.at_xpath('//collectionProp') << 
            Nokogiri::XML(<<-EOF.strip_heredoc).children
              <elementProp name="username" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">false</boolProp>
                <stringProp name="Argument.value">#{value}</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
                <boolProp name="HTTPArgument.use_equals">true</boolProp>
                <stringProp name="Argument.name">#{name}</stringProp>
              </elementProp>
              EOF
        end
        params.delete :fill_in
      end

    end  

  end
end
