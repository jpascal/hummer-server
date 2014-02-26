class AddDescriptionToCases < ActiveRecord::Migration
  def change
    add_column :cases, :description, :text, :default => nil
  end
end
