require 'digest/md5'
require "sinatra/activerecord"

class User < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :password
end
