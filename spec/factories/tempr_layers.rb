FactoryBot.define do
  factory :tempr_layer do
    layer { Layer.first || create(:layer) }
    tempr { Tempr.first || create(:tempr) }
  end
end
