require 'rest-client'

module AddressBook
  class Site

    class << self
      def base_url=(base_url)
        @@base_url = base_url
      end

      def base_url
        @@base_url
      end

      def browser=(browser)
        @@browser = browser
      end

      def browser
        @@browser
      end
    end

    def browser
      @@browser
    end

    def create_user(user = nil)
      user ||= Data::User.new
      call = {url: "#{Site.base_url}/users",
              method: :post,
              payload: {"user[email]" => user.email_address,
                        "user[password]" => user.password}}

      RestClient::Request.execute(call) do |_resp, _req, result|
        header = result.instance_variable_get('@header')
        cookie = header['set-cookie'][1]
        @remember_token = cookie[/^remember_token=([^;]*)/, 1]
      end
      user
    end

    def login(user = nil)
      Home.visit
      user = create_user(user)
      browser.cookies.add 'remember_token', @remember_token
      user
    end

    def logged_in?(user)
      url = "#{Site.base_url}/user.json"

      begin
        h = headers
      rescue StandardError => ex
        raise unless ex.message == 'No token'
        return false
      end

      call = {url: url,
              method: :get,
              headers: h}
      RestClient::Request.execute(call) do |response, _request, result|
        return false if [404, 500].include? response.code
        user == Data::User.convert(JSON.parse(result.body))
      end
    end

    def address?(address)
      address.id
      update_address_id(address) unless address.id
      p = AddressShow.new.page_url(address)
      call = {url: p,
              method: :get,
              headers: headers}
      RestClient::Request.execute(call) do |response, _request, result|
        return false if [404, 500].include? response.code
        doc = Nokogiri::XML(result.body)
        h = Data::Address.keys.each_with_object({}) do |key, hash|
          hash[key] = doc.at_css("span[data-test='#{key}']").text.strip
        end
        Data::Address.new(h) == address
      end
    end

    def create_address(address = nil)
      address ||= Data::Address.new
      payload = address_payload(address)

      call = {url: "#{Site.base_url}/addresses",
              method: :post,
              payload: payload,
              headers: headers}

      RestClient::Request.execute(call) do |_resp, _req, result|
        @id = result.body[/(\d+)[^\d]*$/, 1]
      end

      address.id = @id
      address
    end

    private

    def headers
      cookies = Base.browser.cookies.to_a
      remember = cookies.find { |cookie| cookie[:name] == "remember_token" }
      remember = remember.nil? ? raise(StandardError, 'No token') : remember[:value]
      session_cookie = cookies.find { |cookie| cookie[:name] == "_address_book_session" }
      session = session_cookie.nil? ? '' : session_cookie[:value]
      {'Cookie' => "remember_token=#{remember}; address_book_session=#{session}"}
    end

  end
end
