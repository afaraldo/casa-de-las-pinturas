class AddPersonaToRecibos < ActiveRecord::Migration
  def change
    add_reference :recibos, :persona, index: true
    add_foreign_key :recibos, :personas
  end
end
