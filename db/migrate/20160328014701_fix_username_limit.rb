class FixUsernameLimit < ActiveRecord::Migration
  def change
    # Acortar los nombres de usuarios que sean muy largos
    User.transaction do
      User.with_deleted.each do |u|
        u.update(username: u.username[0..18])
      end
    end

    change_column :users, :username, :string, limit: 20, null: false
  end
end
