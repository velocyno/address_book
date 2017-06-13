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

    # TODO - can this be done by API?
    def logged_in?(user)
      Home.new.signed_in_user == user.email_address
    end

    def address?(address)
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
      remember = cookies.find { |cookie| cookie[:name] == "remember_token" }[:value]
      session_cookie = cookies.find { |cookie| cookie[:name] == "_address_book_session" }
      session = session_cookie.nil? ? '' : session_cookie[:value]
      {'Cookie' => "remember_token=#{remember}; address_book_session=#{session}"}
    end

    def update_address_id(address)
      p = AddressList.new.page_url
      call = {url: p,
              method: :get,
              headers: headers}
      RestClient::Request.execute(call) do |response, _request, result|
        return false if [404, 500].include? response.code
        doc = Nokogiri::XML(result.body)

        addresses = doc.css("tbody tr").map { |r| r.css('td').map(&:text) }
        index = addresses.find_index do |display|
          display.include?(address.first_name) && display.include?(address.last_name)
        end

        id = doc.css("a[data-test^='show']")[index].attributes['data-test'].text[/\d+$/]
        address.tap { |a| a.id = id }
      end
    end
  end
end
