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

    create_table :scrobbles do |t|
      t.string :artist, references: :artist
      t.string :album
      t.string :name
      t.integer :track
      t.datetime :time
      t.integer :length
      t.integer :scrobble_track_id
      t.integer :user_id
    end

    create_table :sessions, id: false, primary_key: :id do |t|
      t.string :id
      t.string :client, limit: 3
      t.string :sessionid, limit: 32
      t.datetime :expires
    end

    add_foreign_key :sessions, :users

    create_user_with_password("ruin", "dood")
  end
end
