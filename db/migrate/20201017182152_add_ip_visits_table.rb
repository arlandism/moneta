class AddIpVisitsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :ip_visits do |t|
      t.inet 'ip'
      t.timestamps
    end
  end
end
