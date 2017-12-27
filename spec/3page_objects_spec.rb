require "spec_helper"

module AddressBook
  describe "Test in Series" do

    it 'Uses Page objects' do
      Home.visit.follow_sign_in
      SignIn.new.follow_sign_up
      user_data = Data::User.new
      SignUp.new.submit_form(user_data)
      expect(Home.new.signed_in_user).to eq user.email_address

      Home.new.sign_out_user
      expect(Home.new.logged_in?).to eq false

      SignIn.new.submit_form(user)
      expect(Home.new.logged_in?).to eq true

      Home.new.follow_addresses
      AddressList.new.follow_new_address
      address = AddressNew.new.submit_form
      expect(AddressShow.new.created_message?).to eq true
      expect(AddressShow.new.address?(address)).to eq true

      AddressShow.new.follow_list
      expect(AddressList.new.number_addresses).to eq 1
      expect(AddressList.new.address?(address)).to eq true

      AddressList.new.follow_edit(address)
      edited_address = AddressEdit.new.submit_form
      expect(AddressShow.new.updated_message?).to eq true
      expect(AddressShow.new.address?(edited_address)).to eq true

      AddressShow.new.follow_list
      AddressList.new.destroy(edited_address)
      expect(AddressList.new.destroyed_message?).to eq true
      expect(AddressList.new.address?(address)).to eq false
    end

  end
end
  