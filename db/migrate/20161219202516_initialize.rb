require_relative '../../models/user'
require_relative '../../helpers/user'

class Initialize < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 64
      t.string :password, limit: 32
    end

    create_table :artists do |t|
      t.string :name
    end

    create_table :albums do |t|
      t.string :name
      t.string :artist
    end

    create_table :tracks do |t| 
      t.string :name
      t.string :artist
      t.string :album
    end

    create_table :scrobble_tracks do |t| 
      t.string :name
      t.string :artist
      t.string :album
      t.integer :track
    end
  end
end
