class CreateRedirects < ActiveRecord::Migration[7.0]
  def change
    create_table :redirects do |t|
      t.string :ncs_id
      t.string :public_uid, null: false

      t.timestamps
    end
    add_index :redirects, :ncs_id, unique: true
    add_index :redirects, :public_uid, unique: true
  end
end
