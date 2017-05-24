class SignUp < BasePage

  page_url { "#{BasePage.base_url}/sign_up" }

  element(:email_address) { browser.text_field(id: "user_email") }
  element(:password) { browser.text_field(id: "user_password") }
  element(:submit) { browser.button(data_test: 'submit') }

  def submit_form(user = nil)
    user ||= Test::User.new
    fill_form(user)
    submit.click
    user
  end
end


