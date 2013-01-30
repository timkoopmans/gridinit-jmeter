module Gridinit
  module Jmeter
    module Helper
      def update(params)
        params.each do |name, value|
          node = @doc.children.xpath("//*[contains(@name,\"#{name.to_s}\")]")
          node.first.content = value unless node.empty? 
        end
      end
    end
  end
end
