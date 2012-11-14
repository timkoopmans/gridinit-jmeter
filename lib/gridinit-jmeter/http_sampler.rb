module Gridinit
  module Jmeter

    class HttpSampler < Hashie::Trash
      property :url,                 :required => true, :default => 'http://localhost'
    end

  end
end