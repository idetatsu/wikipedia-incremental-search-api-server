class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.string :keyword
      t.integer :frequency

      t.timestamps
    end
    add_index :searches, :keyword, :unique => true
  end
end
