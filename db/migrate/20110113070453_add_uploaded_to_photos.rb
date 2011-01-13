class AddUploadedToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos,   :uploaded,    :boolean,     :default => false
    add_column :photos,   :user_id,     :integer
  end

  def self.down
    drop_column :photos, :uploaded
    drop_column :photos, :user_id
  end
end
