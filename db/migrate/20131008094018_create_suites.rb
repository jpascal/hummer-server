class CreateSuites < ActiveRecord::Migration
  def change
    create_table :suites do |t|
      t.text :build
      t.text :description
      t.string :paste
      t.string :tempest
      t.integer :total_tests, :default => 0
      t.integer :total_errors, :default => 0
      t.integer :total_failures, :default => 0
      t.integer :total_skip, :default => 0
      t.timestamps
    end
  end
end
