module Test
  module APISupport

    def create_user(user = nil)
      user ||= Test::User.new

      payload = {"user[email]" => user.email,
                 "user[password]" => user.password}

      call = {url: "#{BasePage.base_site}/users",
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
      cookies = browser.cookies.to_a
      p = Addresses::Show.new.page_url(address)
      headers = {'Cookie' => "remember_token=#{cookies.last[:value]}; address_book_session=#{cookies.first[:value]}"}
      call = {url: p,
              method: :get,
              headers: headers}
      RestClient::Request.execute(call) do |response, request, result|
        return false if response.code == 404
        doc = Nokogiri::XML(result.body)
        h = Test::Address.keys.each_with_object({}) do |key, hash|
          hash[key] = doc.at_css("span[data-test='#{key}']").text.strip
        end
        Test::Address.new(h) == address
      end
    end

    def create_address(address = nil)
      address ||= Test::Address.new
      payload = Test::Address.keys.each_with_object({}) do |key, hash|
        hash["address[#{key}]"] = address.send key
      end

      call = {url: "#{BasePage.base_site}/addresses",
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
      {'Cookie' => "remember_token=#{cookies.first[:value]}; address_book_session=#{cookies.last[:value]}"}
    end

  end
end