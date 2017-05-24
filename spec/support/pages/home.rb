module AddressBook
  class Home < Page::Base

    page_url { Site.base_url }

    element(:current_user) { browser.span(data_test: 'current-user') }
    element(:sign_out) { browser.a(data_test: 'sign-out') }
    element(:sign_in) { browser.a(data_test: 'sign-in') }
    element(:addresses) { browser.a(data_test: 'addresses') }

    def follow_sign_in
      sign_in.click
    end

    def follow_sign_up
      sign_up.click
    end

    def follow_addresses
      addresses.click
    end

    def signed_in_user
      return nil if sign_in.present?
      current_user.text
    end

    def sign_out_user
      sign_out.click
    end

    def logged_in?
      current_user.present?
    end

  end
end
