require 'rubygems'
#gem 'sinatra', '0.9.6'
require 'sinatra'

set :run, false
set :environment, :production

require 'app.rb'
run Sinatra::Application

