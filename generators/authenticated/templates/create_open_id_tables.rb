class CreateOpenIdTables < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string   :nickname
      t.string   :email
      t.string   :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.timestamps
    end

    create_table :identity_urls, :force => true do |t|
      t.integer :user_id
      t.text    :url
      t.timestamps
    end

    create_table :open_id_authentication_associations, :force => true do |t|
      t.integer :issued,     :lifetime
      t.string  :handle,     :assoc_type
      t.binary  :server_url, :secret
    end

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.integer :timestamp,  :null => false
      t.string  :server_url, :null => true
      t.string  :salt,       :null => false
    end

    add_index :identity_urls, :url, :unique => true
  end

  def self.down
    drop_table :open_id_nonces
    drop_table :open_id_associations
    drop_table :identity_urls
    drop_table :users
  end
end
