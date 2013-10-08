class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string      :type
      t.string      :name
      t.text        :message
      t.belongs_to  :case
      t.timestamps
    end
  end
end
