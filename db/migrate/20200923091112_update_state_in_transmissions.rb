class UpdateStateInTransmissions < ActiveRecord::Migration[6.0]
  def up
    Transmission.where(success: true).update_all(state: 'successful')
    Transmission.where(success: false).update_all(state: 'failed')
  end

  def down; end
end
