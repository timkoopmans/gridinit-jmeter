require 'sinatra'

get '/' do
  haml :index
end

post '/' do
  haml :index
end

__END__

@@ layout
%html
  %meta(content="authenticity_token" name="csrf-param")
  = yield

@@ index
%div.title Hello world.