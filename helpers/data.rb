require_relative '../models/init'

def get_or_create_artist(name)
  print name
  Artist.find_or_create_by(name: name)
end

def get_or_create_album(name, artist)
  res = Album.where(name: name, artist: artist)

  if res.empty?
    get_or_create_artist(artist)
    res = Album.create(name: name, artist: artist)
  end

  res
end

def get_or_create_track(name, artist, album)
  res = Track.where(name: name, artist: artist, album: album)

  if res.empty?
    if album != nil
      get_or_create_album(artist, album)
    else
      get_or_create_artist(artist)
    end
    res = Track.create(name: name, artist: artist, album: album)
  end

  res
end

def get_or_create_scrobbletrack(name, artist, album)
  res = ScrobbleTrack.where(name: name, artist: artist, album: album)

  if res.empty?
    track = get_or_create_track(name, artist, album)
    res = ScrobbleTrack.create(name: name, artist: artist, album: album, track: track.id)
  end

  res
end
