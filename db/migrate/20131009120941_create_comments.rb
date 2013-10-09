class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text    :message
      t.string  :resource_type
      t.integer :resource_id
      t.timestamps
    end
  end
end
