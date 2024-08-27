class AddClickCountAndLastClickToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :click_count, :integer, default: 0
    add_column :links, :last_click, :datetime
  end
end
