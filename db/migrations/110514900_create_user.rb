class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :encrypted_password
      t.string :token
      t.string :temp_token
      t.string :role

      t.timestamps
    end
  end
end
