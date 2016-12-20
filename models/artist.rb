class Artist < ActiveRecord::Base
  def get_or_create(name)
    Artist.find_by_or_create({name: name})
  end
end
