require 'digest/md5'
require_relative '../models/user'

def check_auth(username, token, timestamp)
  hash = User.where(name: username).first.password
  return false if !hash
  Digest::MD5.hexdigest(hash + timestamp.to_s) == token
end

def check_session(id)
  time = Time.now.to_i

  return time > 0
end
