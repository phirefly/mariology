describe "Canceling a request" do
  let (:client_data) { FactoryGirl.create(:ncr_work_order) }
  let (:proposal) { FactoryGirl.create(:proposal, :with_approver, client_data_type: "Ncr::WorkOrder", client_data_id: client_data.id) }

  before do
    login_as(proposal.requester)
  end

  it "shows a cancel link for the requester" do
    visit proposal_path(proposal)
    expect(page).to have_content("Cancel my request")
  end

  it "does not show a cancel link for non-requesters" do
    login_as(proposal.approvers.first)
    visit proposal_path(proposal)
    expect(page).to_not have_content("Cancel my request")
  end

  it "prompts the requester for a reason" do
    visit proposal_path(proposal)
    click_on('Cancel my request')
    expect(current_path).to eq("/proposals/#{proposal.id}/cancel_form")
  end

  it "redirects if trying to see the cancellation page on proposals you have not rquested" do
    login_as(proposal.approvers.first)
    visit cancel_form_proposal_path(proposal)
    expect(page).to have_content("You are not allowed to perform that action")
    expect(current_path).to eq("/proposals")
  end

  it "successfully sends and notifies the user" do
  end


end
