class SignIn < BasePage

  page_url { "#{BasePage.base_url}/sign_in" }


  element(:email_address) { browser.text_field(id: "session_email") }
  element(:password) { browser.text_field(id: "session_password") }
  element(:submit) { browser.button(visible: true) }
  element(:sign_up) { browser.a(data_test: 'sign-up') }

  def submit_form(user = nil)
    user ||= Test::User.new
    fill_form(user)
    submit.click
    user
  end

  def follow_sign_up
    sign_up.click
  end

end
