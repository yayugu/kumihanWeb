#!/usr/bin/ruby 

require 'rubygems'
gem 'sinatra', '0.9.6'
require 'sinatra'

get '' do
  'Hello world!'
end

set :run => false, :env => :cgi
Rack::Handler::CGI.run Sinatra.application

