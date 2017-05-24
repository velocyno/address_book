require 'nokogiri'

module AddressBook
  class Site

    def browser
      WatirDrops::PageObject.browser
    end


    def create_user(user = nil)
      user ||= AddressBook::Data::User.new

      payload = {"user[email]" => user.email_address,
                 "user[password]" => user.password}

      call = {url: "#{AddressBook::Base.base_url}/users",
              method: :post,
              payload: payload}

      RestClient::Request.execute(call) do |response, request, result|
        @remember_token = result.instance_variable_get('@header')['set-cookie'][1][/^remember_token=([^;]*)/, 1]
      end
      user
    end

    def log_in_user(user = nil)
      Home.visit
      create_user(user)
      browser.cookies.add 'remember_token', @remember_token
      user
    end

    def address_present?(address)
      p = AddressBook::Address::Show.new.page_url(address)
      call = {url: p,
              method: :get,
              headers: headers}
      RestClient::Request.execute(call) do |response, _request, result|
        return false if [404, 500].include? response.code
        doc = Nokogiri::XML(result.body)
        h = AddressBook::Data::Address.keys.each_with_object({}) do |key, hash|
          hash[key] = doc.at_css("span[data-test='#{key}']").text.strip
        end
        AddressBook::Data::Address.new(h) == address
      end
    end

    def create_address(address = nil)
      address ||= Data::Address.new
      payload = address.keys.each_with_object({}) do |key, hash|
        hash["address[#{key}]"] = address.send key
      end

      call = {url: "#{Base.base_url}/addresses",
              method: :post,
              payload: payload,
              headers: headers}

      RestClient::Request.execute(call) do |response, request, result|
        @id = result.body[/(\d+)[^\d]*$/, 1]
      end

      address.tap { |a| a.id = @id }
    end

    private

    def headers
      cookies = browser.cookies.to_a
      remember = cookies.find { |cookie| cookie[:name] == "remember_token" }[:value]
      session_cookie = cookies.find { |cookie| cookie[:name] == "_address_book_session" }
      session = session_cookie.nil? ? '' : session_cookie[:value]
      {'Cookie' => "remember_token=#{remember}; address_book_session=#{session}"}
    end

  end
end
