require "spec_helper"

describe "Test in Parallel" do

  let(:user) { Test::User.new }
  let(:address) { Test::Address.new }

  it 'signs up' do
    SignUp.visit.submit_form(user)

    expect(Home.visit.signed_in_user).to eq user.email_address
  end

  it 'login' do
    SignUp.visit.submit_form(user)
    Home.new.sign_out_user

    SignIn.visit.submit_form(user)

    expect(Home.new.logged_in?).to eq true
  end

  it 'logout' do
    SignUp.visit.submit_form(user)

    Home.new.sign_out_user

    expect(Home.new.logged_in?).to eq false
  end

  it 'creates address' do
    SignUp.visit.submit_form

    Addresses::New.visit.submit_form(address)

    expect(Addresses::Show.new.created_message?).to eq true
    expect(Addresses::Show.new.address?(address)).to eq true
  end

  it 'shows' do
    SignUp.visit.submit_form

    Addresses::New.visit.submit_form(address)

    expect(Addresses::Show.new.address?(address)).to eq true
  end

  it 'lists' do
    SignUp.visit.submit_form
    Addresses::New.visit.submit_form(address)
    address2 = Addresses::New.visit.submit_form

    expect(Addresses::List.visit.present?(address)).to eq true
    expect(Addresses::List.visit.present?(address2)).to eq true
  end

  it 'edits' do
    SignUp.visit.submit_form
    Addresses::New.visit.submit_form(address)
    Addresses::Show.new.update_address(address)

    edited_address = Addresses::Edit.visit(address).submit_form

    expect(Addresses::Show.new.updated_message?).to eq true
    expect(Addresses::Show.new.address?(edited_address)).to eq true
  end

  it 'deletes address' do
    SignUp.visit.submit_form
    Addresses::New.visit.submit_form(address)

    Addresses::List.visit.destroy(address)

    expect(Addresses::List.new.destroyed_message?).to eq true
    expect(Addresses::List.new.present?(address)).to eq false
  end

end
