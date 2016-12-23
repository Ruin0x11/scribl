require 'sinatra'

require_relative '../models/init'
require_relative '../helpers/user'
require_relative '../helpers/data'

class Scribl < Sinatra::Base
  def validate(str)
    str.strip!
    return false if str.empty?
    true
  end

  post "/submit" do
    if ['s', 'a', 't', 'i'].any? { |s| !params.key?(s) || params[s].empty? }
      halt 400, "FAILED Missing required parameters\n"
    end

    if ['t','a','i'].any? { |s| !params[s].kind_of?(Hash) }
      halt 400, "FAILED Track parameters must be arrays\n"
    end

    session_id = params['s']
    user = user_from_session(session_id)
    halt 400, "BADSESSION\n" if user.nil?
    user_id = user.id

    i = 0

    while i < params["t"].length
      # "p[123]=bobo" => {"p"=>{"123"=>"bobo"}}
      track = params["t"][i.to_s]
      artist = params["a"][i.to_s]
      time = params["i"][i.to_s]

      halt 400, "FAILED Empty artist/track field\n" if [artist, track].any? { |s| !validate(s) }

      if params.key?("b")
        album = params["b"][i.to_s]
        halt 400, "FAILED Empty album field\n" if !validate(album)
      end

      if params.key?("o")
        source = params["o"][i.to_s]
      else
        source = nil
      end

      if params.key?("l")
        length = params["l"][i.to_s]
      else
        length = nil
      end

      if time.to_i - Time.now.to_i > 300
        halt 400, "FAILED Submitted track has timestamp in the future\n"
      end

      if Scrobble.where(user_id: user_id, artist: artist, album: album, time: time).empty?
        scrobble_track_id = get_or_create_scrobbletrack(track, artist, album).id
        Scrobble.create(user_id: user_id, artist: artist, album: album, name: track, time: DateTime.strptime(time, '%s'), length: length, scrobble_track_id: scrobble_track_id)
      end

      i += 1
    end
    "OK\n"
  end
end
