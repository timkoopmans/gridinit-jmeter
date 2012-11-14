module Gridinit
  module Jmeter

    class Transaction < Hashie::Trash

      def visit(params={}, &block)
        @actions ||= []
        @actions << Docile.dsl_eval(Gridinit::Jmeter::HttpSampler.new, params, &block)
      end

    end

  end
end