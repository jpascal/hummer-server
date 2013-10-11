class CreateResults < ActiveRecord::Migration
  def change
    create_table :results, :id => :uuid do |t|
      t.string      :type
      t.string      :name
      t.text        :message
      t.uuid        :case_id
      t.timestamps
    end
  end
end
