require 'sinatra'

get '/' do
  haml :index
end

post '/' do
  logger.info params
  haml :index
end

__END__

@@ layout
%html
  %meta(content="XAWfTfoqH9eOQy4ZN1U4z+rzfnC/hihb5lWv4VLRY5g=" name="csrf-token")
  = yield

@@ index
%div.title Hello world.