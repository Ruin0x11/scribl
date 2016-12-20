class Track < ActiveRecord::Base
  def get_or_create(name, artist, album)
    res = Track.where({name: name, artist: artist, album: album})

    if !res
      if album != 'NULL'
        Album.create_if_new(artist, album)
      else
        Artist.create_if_new(artist)
      end
      res = Track.create(name: name, artist: artist, album: album)
    end

    res
  end
end
