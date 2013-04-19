module Gridinit
  module Jmeter
    module Helper
      def update(params)
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty?
        end
      end

      def enabled(params)
        #default to true unless explicitly set to false
        if params.has_key?(:enabled) && params[:enabled] == false
          'false'
        else
          'true'
        end
      end
    end
  end
end
