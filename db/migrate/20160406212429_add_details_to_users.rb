class AddDetailsToUsers < ActiveRecord::Migration
  def change
    User.transaction do |u|
      u.update(rol: (u.username == 'admin' ? 'superusuario' : 'administrador'))
    end
    add_column :users, :rol, :string, limit: 20, null: false
    add_column :users, :deleted_at, :date
    add_index :users, :deleted_at
  end
end
