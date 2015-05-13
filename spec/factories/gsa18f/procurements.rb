FactoryGirl.define do
  factory :gsa18f_procurement, class: Gsa18f::Procurement, parent: :proposal do
    cost_per_unit 1000
    quantity 3
    additional_info "none"
    sequence(:product_name_and_description) {|n| "Proposal #{n}" }
    office Gsa18f::Procurement::OFFICES[0]
    urgency Gsa18f::Procurement::URGENCY[0]
    flow 'linear'
  end
end
