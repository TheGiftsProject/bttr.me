class FirstMigration < ActiveRecord::Migration
  def self.up
    create_table :missions do |t|
      t.string :name
      t.integer :foursquare_id
      t.integer :multiplier,:default=>1
      t.boolean :min,:default=>1
      t.string :timespan,:default=>"week"
      t.timestamps
    end

    create_table :filters do |t|
      t.string :type
      t.string :venue
      t.string :category
      t.integer :hour
      t.boolean :before_hour,:default=>1
      t.integer :friend_id
      t.references :mission
      t.timestamps
    end
  end

  def self.down
    drop_table :filters

    drop_table :missions
  end
end
