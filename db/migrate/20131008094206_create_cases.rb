class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases, :id => :uuid do |t|
      t.string      :classname, :null => false
      t.string      :name, :null => false
      t.float       :time, :default => 0.0
      t.string      :paste
      t.uuid        :suite_id
      t.string      :tracker
      t.timestamps
    end
  end
end
