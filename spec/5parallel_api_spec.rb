require "spec_helper"

describe "Test in Parallel" do

  let(:user) { AddressBook::Data::User.new }
  let(:address) { AddressBook::Data::Address.new }

  it 'signup' do
    SignUp.visit.submit_form(user)
    expect(Home.new.signed_in_user).to eq user.email_address
  end

  it 'login' do
    Site.new.create_user(user)

    SignIn.visit.submit_form(user)
    expect(Home.new.logged_in?).to eq true
  end

  it 'logout' do
    Site.new.log_in_user(user)

    Home.visit.sign_out_user
    expect(Home.new.logged_in?).to eq false
  end

  it 'creates' do
    Site.new.log_in_user(user)

    AddressBook::Address::New.visit.submit_form(address)
    expect(AddressBook::Address::Show.new.created_message?).to eq true
    expect(AddressBook::Address::List.visit.present?(address)).to eq true
  end

  it 'shows' do
    Site.new.log_in_user(user)
    Site.new.create_address(address)

    expect(AddressBook::Address::Show.visit(address).address?(address)).to eq true
  end

  it 'lists' do
    Site.new.log_in_user(user)
    Site.new.create_address(address)

    expect(AddressBook::Address::List.visit.present?(address)).to eq true
  end

  it 'edits' do
    Site.new.log_in_user(user)
    Site.new.create_address(address)

    edited_address = AddressBook::Address::Edit.visit(address).submit_form
    expect(AddressBook::Address::Show.new.updated_message?).to eq true
    expect(AddressBook::Address::Show.new.address?(edited_address)).to eq true
  end

  it 'deletes' do
    Site.new.log_in_user(user)
    Site.new.create_address(address)

    AddressBook::Address::List.visit.destroy(address)
    expect(AddressBook::Address::List.new.destroyed_message?).to eq true
    expect(AddressBook::Address::List.new.present?(address)).to eq false
  end

end
