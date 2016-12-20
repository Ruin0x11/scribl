require 'sinatra'
require 'digest/md5'

require_relative 'util'
require_relative 'models/user'
require_relative 'models/session'

class Scribl < Sinatra::Base
  SUPPORTED_PROTOCOLS = ['1.2', '1.2.1']

  post '/asd' do
    "dood"
  end

  post '/handshake' do
    if !['p','u','t','a','c'].all? { |s| params.key?(s) }
      halt "BADAUTH Required fields not included\n"
    end

    protocol = params['p']
    username = params['u']
    timestamp = params['t'].to_i
    auth_token = params['a']
    client = params['c']

    if !SUPPORTED_PROTOCOLS.include?(protocol)
      halt "FAILED Unsupported protocol version\n"
    end

    if timestamp - Time.now.to_i > 300
      halt "BADAUTH Timestamp in the future\n"
    end

    p timestamp
    is_authorized = check_auth(username, auth_token, timestamp)

    if !is_authorized
      halt "BADAUTH Not authorized\n"
    end

    user_id = User.where(name: username).first.id
    session_id = Digest::MD5.hexdigest(auth_token + Time.now.to_i.to_s)

    Session.create(id: user_id.to_s, sessionid: session_id, client: client, expires: Time.now.to_i + 24.hours.to_i)

    "OK\n#{session_id}\nexample.com/nowplaying/1.2\nexample.com/submissions/1.2\n"
  end
end
