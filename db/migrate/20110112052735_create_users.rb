class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string        :token
      t.string        :secret
      t.string        :twitter_id
      t.string        :screen_name
      t.timestamps
    end

    add_index :users, :twitter_id
  end

  def self.down
    drop_table :users
  end
end
