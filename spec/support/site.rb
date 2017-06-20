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
    end

    def create_user(user = nil)
      user ||= Data::User.new

      payload = {"user[email]" => user.email_address,
                 "user[password]" => user.password}

      call = {url: "#{Site.base_url}/users",
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
      Base.browser.cookies.add 'remember_token', @remember_token
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

    def address_list
      url = "#{Site.base_url}/addresses.json"
      call = {url: url,
              method: :get,
              headers: headers}
      RestClient::Request.execute(call) do |response, _request, result|
        return false if [404, 500].include? response.code
        JSON.parse(result.body).map { |address| Data::Address.convert(address) }
      end
    end

    def address?(address)
      address_list.include? address
    end

    def create_address(address = nil)
      address ||= Data::Address.new
      payload = address.keys.each_with_object({}) do |key, hash|
        hash["address[#{key}]"] = address.send key
      end

      call = {url: "#{Site.base_url}/addresses",
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
      cookies = Base.browser.cookies.to_a
      remember = cookies.find { |cookie| cookie[:name] == "remember_token" }
      remember = remember.nil? ? raise(StandardError, 'No token') : remember[:value]
      session_cookie = cookies.find { |cookie| cookie[:name] == "_address_book_session" }
      session = session_cookie.nil? ? '' : session_cookie[:value]
      {'Cookie' => "remember_token=#{remember}; address_book_session=#{session}"}
    end

  end
end
