require "spec_helper"

describe "Test in Series" do

  it 'Uses Page objects' do
    Home.visit.follow_sign_in
    SignIn.new.follow_sign_up
    user = AddressBook::Data::User.new
    SignUp.new.submit_form(user)
    expect(Home.new.signed_in_user).to eq user.email_address

    Home.new.sign_out_user
    expect(Home.new.logged_in?).to eq false

    SignIn.new.submit_form(user)
    expect(Home.new.logged_in?).to eq true

    Home.new.follow_addresses
    AddressBook::Address::List.new.new_address_link
    address = AddressBook::Address::New.new.submit_form
    expect(AddressBook::Address::Show.new.created_message?).to eq true
    expect(AddressBook::Address::Show.new.address?(address)).to eq true

    AddressBook::Address::Show.new.follow_list
    expect(AddressBook::Address::List.new.number_addresses).to eq 1
    expect(AddressBook::Address::List.new.present?(address)).to eq true

    AddressBook::Address::List.new.follow_edit(address)
    edited_address = AddressBook::Address::Edit.new.submit_form
    expect(AddressBook::Address::Show.new.updated_message?).to eq true
    expect(AddressBook::Address::Show.new.address?(edited_address)).to eq true

    AddressBook::Address::Show.new.follow_list
    AddressBook::Address::List.new.destroy(edited_address)
    expect(AddressBook::Address::List.new.destroyed_message?).to eq true
    expect(AddressBook::Address::List.new.present?(address)).to eq false
  end

end
