#!/usr/bin/ruby 

require 'rubygems'
gem 'sinatra', '0.9.6'
require 'sinatra'

#patch when Rack with CGI with POST method error
module Rack
  class Request
    def POST
      if @env["rack.request.form_input"].eql? @env["rack.input"]
        @env["rack.request.form_hash"]
      elsif form_data? || parseable_data?
        @env["rack.request.form_input"] = @env["rack.input"]
        unless @env["rack.request.form_hash"] =
            Utils::Multipart.parse_multipart(env)
          form_vars = @env["rack.input"].read

          # Fix for Safari Ajax postings that always append \0
          form_vars.sub!(/\0\z/, '')

          @env["rack.request.form_vars"] = form_vars
          @env["rack.request.form_hash"] = Utils.parse_nested_query(form_vars)

          ### changed here(ignore Errno::ESPIE exception) ###
          begin
            @env["rack.input"].rewind
          rescue Errno::ESPIPE
          end
          ### end ###
        end
        @env["rack.request.form_hash"]
      else
        {}
      end
    end
  end
end

load "main.rb"
#set :run => false, :env => :cgi
#Rack::Handler::CGI.run Sinatra.application

