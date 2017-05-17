require "spec_helper"

describe "Test in Series" do

  it 'Uses Page objects' do
    Home.visit.sign_in_link
    SignIn.new.sign_up_link
    user = User.new
    SignUp.new.submit_form(user)
    expect(NavBar.new.signed_in_user).to eq user.email

    NavBar.new.sign_out_user
    expect(NavBar.new.logged_in?).to eq false

    SignIn.new.submit_form(user)
    expect(NavBar.new.logged_in?).to eq true

    NavBar.new.addresses_link
    Addresses::List.new.new_address_link
    address = Addresses::New.new.submit_form
    expect(Addresses::Show.new.created_message?).to eq true
    expect(Addresses::Show.new.address?(address)).to eq true

    Addresses::Show.new.follow_list
    expect(Addresses::List.new.number_addresses).to eq 1
    expect(Addresses::List.new.present?(address)).to eq true

    Addresses::List.new.follow_edit(address)
    edited_address = Addresses::Edit.new.submit_form
    expect(Addresses::Show.new.updated_message?).to eq true
    expect(Addresses::Show.new.address?(edited_address)).to eq true

    Addresses::Show.new.follow_list
    Addresses::List.new.destroy(edited_address)
    expect(Addresses::List.new.destroyed_message?).to eq true
    expect(Addresses::List.new.present?(address)).to eq false
  end

end
