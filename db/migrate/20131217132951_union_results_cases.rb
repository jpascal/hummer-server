class UnionResultsCases < ActiveRecord::Migration
  def up
    add_column :cases, :type, :string
    add_column :cases, :message, :text
    Case.all.each do |test|
      test.message = test.result.message
      test.type = test.result.type
      test.save!
    end
    drop_table :results
  end
  def down
    create_table :results, :id => :uuid do |t|
      t.string      :type
      t.string      :name
      t.text        :message
      t.uuid        :case_id
      t.timestamps
    end
    Case.all.each do |test|
      Result.create!(:case_id => test.id, :type => test.type, :message => test.message)
    end
    remove_column :cases, :type, :string
    remove_column :cases, :message, :text
  end
end
