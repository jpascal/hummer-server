class AddCaseNameIndex < ActiveRecord::Migration
  def change
    add_index(:cases, :name)
  end
end
