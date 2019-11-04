class UpdateAccountIdOnTemprs < ActiveRecord::Migration[6.0]
  def up
    Tempr.all.each do |tempr|
      tempr.account = tempr.device_group.account
      tempr.save
    end
  end
end
