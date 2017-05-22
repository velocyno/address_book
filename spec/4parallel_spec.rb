require "spec_helper"

describe "Test in Parallel" do

  it 'signup' do
    user = Test::User.new
    SignUp.visit.submit_form(user)
    expect(NavBar.new.signed_in_user).to eq user.email
  end

  it 'logout' do
    Test::AddressBook.new.log_in_user
    Home.visit
    NavBar.new.sign_out_user
    expect(NavBar.new.logged_in?).to eq false
  end

  it 'login' do
    user = Test::AddressBook.new.create_user
    SignIn.visit.submit_form(user)
    expect(NavBar.new.logged_in?).to eq true
  end

  it 'creates address' do
    Test::AddressBook.new.log_in_user
    address = Addresses::New.visit.submit_form
    expect(Addresses::Show.new.created_message?).to eq true
    expect(Test::AddressBook.new.address_present?(address)).to eq true
  end

  it 'shows address' do
    Test::AddressBook.new.log_in_user
    address = Test::AddressBook.new.create_address
    expect(Addresses::Show.visit(address).address?(address)).to eq true
  end

  it 'lists addresses' do
    Test::AddressBook.new.log_in_user
    address = Test::AddressBook.new.create_address
    expect(Addresses::List.visit.present?(address)).to eq true
  end

  it 'edits address' do
    Test::AddressBook.new.log_in_user
    address = Test::AddressBook.new.create_address
    edited_address = Addresses::Edit.visit(address).submit_form
    expect(Addresses::Show.new.updated_message?).to eq true
    expect(Test::AddressBook.new.address_present?(edited_address)).to eq true
  end

  it 'deletes address' do
    Test::AddressBook.new.log_in_user
    address = Test::AddressBook.new.create_address
    Addresses::List.visit.destroy(address)
    expect(Addresses::List.new.destroyed_message?).to eq true
    expect(Test::AddressBook.new.address_present?(address)).to eq false
  end

end
