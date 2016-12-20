require 'sinatra'

require_relative 'models/init'
require_relative 'helpers/user'
require_relative 'helpers/data'

class Scribl < Sinatra::Base
  def validate(str)
    str.strip!
    return false if str.empty?
    true
  end

  post "/submit" do
    if ['s', 'a', 't', 'i'].any? { |s| !params.key?(s) || params[s].empty? }
      halt "FAILED\n"
    end

    if ['t','a','i'].any? { |s| !params[s].kind_of?(Hash) }
      halt "FAILED Track parameters must be arrays\n"
    end

    session_id = params['s']
    user_id = user_from_session(session_id)

    i = 0

    while i < params["t"].length
      # "p[123]=bobo" => {"p"=>{"123"=>"bobo"}}
      track = params["t"][i.to_s]
      artist = params["a"][i.to_s]
      time = params["i"][i.to_s]

      halt "FAILED\n" if [artist, track].any? { |s| !validate(s) }

      if params.key?("b")
        album = params["b"]
        halt "FAILED\n" if !validate(b)
      end

      if params.key?("o")
        source = params["o"]
      else
        source = nil
      end

      if params.key?("l")
        length = params["l"]
      else
        length = nil
      end

      if time.to_i - Time.now.to_i > 300
        halt "FAILED Submitted track has timestamp in the future\n"
      end

      if Scrobble.where(user_id: user_id, artist: artist, album: album, time: time).empty?
        scrobble_track_id = get_or_create_scrobbletrack(track, artist, album)
        Scrobble.create(user_id: user_id, artist: artist, album: album, name: track, time: time, length: length, scrobble_track_id: scrobble_track_id)
      end

      i += 1
    end
    "OK\n"
  end
end
