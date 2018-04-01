require 'sinatra/base'
require "sinatra/reloader"
require "sinatra/activerecord"

require_relative './routes/init'
require_relative './models/init'
require_relative './helpers/init'

class Scribl < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  before do
    content_type :json
  end

  configure do
    set :app_file, __FILE__
  end

  configure :development do
    register Sinatra::Reloader
    enable :logging, :dump_errors, :raise_errors
  end

  configure :production do
    set :raise_errors, false
    set :show_exceptions, false
  end
end
