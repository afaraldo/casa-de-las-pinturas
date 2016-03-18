class AddPersonaRefToUser < ActiveRecord::Migration
  def change
    add_reference :users, :persona, index: true
    add_foreign_key :users, :personas
  end
end
