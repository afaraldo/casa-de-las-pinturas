class AddDetailsToUsers < ActiveRecord::Migration
  def change

    add_column :users, :rol, :string, limit: 20

    User.transaction do
      User.with_deleted.each do |u|
        u.update(rol: (u.username == 'admin' ? 'superusuario' : 'administrador'))
      end
    end

    change_column_null :users, :rol, false
    add_column :users, :deleted_at, :date
    add_index :users, :deleted_at
  end
end
