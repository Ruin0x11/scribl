class CreateReferenceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :scrobbles do |t|
      t.string :artist, references: :artist
      t.string :album
      t.string :name
      t.datetime :time
      t.integer :length
      t.references :scrobble_track, index: true
      t.references :user, index: true
    end

    create_table :sessions, id: false, primary_key: :id do |t|
      t.string :id
      t.string :client, limit: 3
      t.string :sessionid, limit: 32
      t.datetime :expires
      t.references :user, index: true
    end
  end
end
