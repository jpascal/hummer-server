class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.string      :classname, :null => false
      t.string      :name, :null => false
      t.float       :time, :default => 0.0
      t.belongs_to  :suite
      t.timestamps
    end
  end
end
