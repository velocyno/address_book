class Home < BasePage

  page_url { BasePage.base_url }

  element(:current_user) { browser.span(data_test: 'current-user') }
  element(:sign_out) { browser.a(data_test: 'sign-out') }
  element(:sign_in) { browser.a(data_test: 'sign-in') }

  def sign_in_link
    sign_in.click
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
