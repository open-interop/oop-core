class UpdateAccountIdOnTemprs < ActiveRecord::Migration[6.0]
  def up
    Tempr.all.each do |tempr|
      tempr.update_column(:account_id, tempr.device_group&.account_id)
    end
  end
end
