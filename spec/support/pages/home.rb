module AddressBook
  class Home < AddressBook::Base

    page_url { AddressBook::Base.base_url }


    element(:current_user) { browser.span(data_test: 'current-user') }
    element(:logout) { browser.a(data_test: 'sign-out') }
    element(:sign_in) { browser.a(data_test: 'sign-in') }
    element(:addresses) { browser.a(data_test: 'addresses') }

    def logged_in?
      current_user.present?
    end

    def signed_in_user
      current_user.text
    end

    def sign_out_user
      logout.click
    end

    def follow_addresses
      addresses.click
    end

    def follow_sign_in
      sign_in.click
    end

  end
end
