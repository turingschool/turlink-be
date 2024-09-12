class AddPrivateToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :private, :boolean, default: false
  end
end
