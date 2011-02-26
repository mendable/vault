class CreateSchema < ActiveRecord::Migration

  create_table :cards do |t|
    t.string :number
    t.integer :month
    t.integer :year
    t.integer :start_month
    t.integer :start_year
    t.integer :issue_number
    t.timestamps
  end

end
