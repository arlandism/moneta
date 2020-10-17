class AddIpIndex < ActiveRecord::Migration[5.2]
  def change
    add_index(:ip_visits, :ip)
  end
end
