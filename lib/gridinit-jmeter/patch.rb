module Docile
  def dsl_eval(dsl, params={}, &block)
    block_context = eval("self", block.binding)
    proxy_context = FallbackContextProxy.new(dsl, block_context)
    begin
      block_context.instance_variables.each { |ivar| proxy_context.instance_variable_set(ivar, block_context.instance_variable_get(ivar)) }
      proxy_context.instance_eval(&block)
      params.each {|k,v| dsl[k] = v }
    ensure
      block_context.instance_variables.each { |ivar| block_context.instance_variable_set(ivar, proxy_context.instance_variable_get(ivar)) }
    end
    dsl
  end
  module_function :dsl_eval
end