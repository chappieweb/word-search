class CreateOrgs < ActiveRecord::Migration
  def change
    create_table :orgs do |t|
      t.string :name
      t.integer :parent

      t.timestamps
    end
  end
end
