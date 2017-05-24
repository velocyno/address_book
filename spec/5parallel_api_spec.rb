require "spec_helper"

describe "Test in Parallel" do

  let(:user) { Test::User.new }
  let(:address) { Test::Address.new }

  it 'signs up' do
    SignUp.visit.submit_form(user)
    expect(Test::AddressBook.new.logged_in?(user)).to eq true
  end

  it 'login' do
    Test::AddressBook.new.create_user(user)

    SignIn.visit.submit_form(user)

    expect(Test::AddressBook.new.logged_in?(user)).to eq true
  end

  it 'logout' do
    Test::AddressBook.new.log_in_user(user)

    Home.visit.sign_out_user

    expect(Test::AddressBook.new.logged_in?(user)).to eq false
  end

  it 'creates address' do
    Test::AddressBook.new.log_in_user(user)

    Addresses::New.visit.submit_form(address)

    expect(Addresses::Show.new.created_message?).to eq true
    expect(Test::AddressBook.new.address?(address)).to eq true
  end

  it 'shows' do
    Test::AddressBook.new.log_in_user(user)
    Test::AddressBook.new.create_address(address)

    expect(Addresses::Show.visit(address).address?(address)).to eq true
  end

  it 'lists' do
    Test::AddressBook.new.log_in_user(user)
    Test::AddressBook.new.create_address(address)
    address2 = Test::AddressBook.new.create_address

    expect(Addresses::List.visit.present?(address)).to eq true
    expect(Addresses::List.visit.present?(address2)).to eq true
  end

  it 'edits' do
    Test::AddressBook.new.log_in_user(user)
    Test::AddressBook.new.create_address(address)

    edited_address = Addresses::Edit.visit(address).submit_form

    expect(Addresses::Show.new.updated_message?).to eq true
    expect(Test::AddressBook.new.address?(edited_address)).to eq true
  end

  it 'deletes address' do
    Test::AddressBook.new.log_in_user(user)
    Test::AddressBook.new.create_address(address)

    Addresses::List.visit.destroy(address)

    expect(Addresses::List.new.destroyed_message?).to eq true
    expect(Test::AddressBook.new.address?(address)).to eq false
  end

end
