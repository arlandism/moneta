class AddIpIndex < ActiveRecord::Migration[5.2]
  def change
    add_index(:ip_visits, :ip, unique: true)
  end
end
