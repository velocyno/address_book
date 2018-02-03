require "spec_helper"
require "nokogiri"

module AddressBook
  describe "Test in Parallel with APIs" do

    let(:user) { Data::User.new }
    let(:address) { Data::Address.new }
    let(:site) { Site.new }

    it 'signs up' do
      SignUp.visit.submit_form(user)
      expect(site.logged_in?(user)).to eq true
    end

    it 'login' do
      site.create_user(user)

      SignIn.visit.submit_form(user)

      expect(site.logged_in?(user)).to eq true
    end

    it 'logout' do
      site.login(user)

      Home.visit.sign_out_user

      expect(site.logged_in?(user)).to eq false
    end

    it 'creates address' do
      site.login

      AddressNew.visit
          #.submit_form(address)

      expect(AddressShow.new.created_message?).to eq true
      expect(site.address?(address)).to eq true
    end

    it 'shows' do
      site.log_in_user(user)
      site.create_address(address)

      expect(AddressShow.visit(address).address?(address)).to eq true
    end

    it 'lists' do
      site.log_in_user(user)
      site.create_address(address)
      address2 = site.create_address

      expect(AddressList.visit.address?(address)).to eq true
      expect(AddressList.visit.address?(address2)).to eq true
    end

    it 'edits' do
      site.log_in_user(user)
      site.create_address(address)

      edited_address = AddressEdit.visit(address).submit_form

      expect(AddressShow.new.updated_message?).to eq true
      expect(site.address?(edited_address)).to eq true
    end

    it 'deletes address' do
      site.log_in_user(user)
      site.create_address(address)

      AddressList.visit.destroy(address)

      expect(AddressList.new.destroyed_message?).to eq true
      expect(site.address?(address)).to eq false
    end

  end
end
