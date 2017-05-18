class Home < BasePage

  page_url { '/' }

  element(:sign_in) { browser.a(data_test: 'sign-in') }

  def sign_in_link
    sign_in.click
  end

end


