class AddSummaryToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :summary, :text, default: nil
    add_column :links, :summary_timestamp, :datetime, default: nil
  end
end
