require 'sinatra'
require_relative 'handshake'
require_relative 'submit'

require "sinatra/activerecord"
set :database, {adapter: "sqlite3", database: "scribl.sqlite3"}

class Scribl < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  before do
    content_type :json
  end

  get '/' do
    "Doing it my way. #{Time.now}"
  end
end
