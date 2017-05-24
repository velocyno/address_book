require "spec_helper"

module AddressBook
  describe "Test in Parallel" do

    let(:user) { Data::User.new }
    let(:address) { Data::Address.new }

    it 'signs up' do
      SignUp.visit.submit_form(user)
      expect(Site.new.logged_in?(user)).to eq true
    end

    it 'login' do
      Site.new.create_user(user)

      SignIn.visit.submit_form(user)

      expect(Site.new.logged_in?(user)).to eq true
    end

    it 'logout' do
      Site.new.log_in_user(user)

      Home.visit.sign_out_user

      expect(Site.new.logged_in?(user)).to eq false
    end

    it 'creates address' do
      Site.new.log_in_user(user)

      AddressNew.visit.submit_form(address)

      expect(AddressShow.new.created_message?).to eq true
      expect(Site.new.address?(address)).to eq true
    end

    it 'shows' do
      Site.new.log_in_user(user)
      Site.new.create_address(address)

      expect(AddressShow.visit(address).address?(address)).to eq true
    end

    it 'lists' do
      Site.new.log_in_user(user)
      Site.new.create_address(address)
      address2 = Site.new.create_address

      expect(AddressList.visit.address?(address)).to eq true
      expect(AddressList.visit.address?(address2)).to eq true
    end

    it 'edits' do
      Site.new.log_in_user(user)
      Site.new.create_address(address)

      edited_address = AddressEdit.visit(address).submit_form

      expect(AddressShow.new.updated_message?).to eq true
      expect(Site.new.address?(edited_address)).to eq true
    end

    it 'deletes address' do
      Site.new.log_in_user(user)
      Site.new.create_address(address)

      AddressList.visit.destroy(address)

      expect(AddressList.new.destroyed_message?).to eq true
      expect(Site.new.address?(address)).to eq false
    end

  end
end
