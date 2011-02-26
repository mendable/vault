class CreateSchema < ActiveRecord::Migration

  create_table :cards do |t|
    t.string :number
    t.timestamps
  end

end
