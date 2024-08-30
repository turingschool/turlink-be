class AddDisabledToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :disabled, :boolean, default: false
  end
end
