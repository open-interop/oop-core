FactoryBot.define do
  factory :tempr_layer do
    layer { Layer.first || create(:layer) }
    tempr { Tempr.first || create(:tempr) }
  end
end

# == Schema Information
#
# Table name: tempr_layers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  layer_id   :integer
#  tempr_id   :integer
#
