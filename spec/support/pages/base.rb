class BasePage < WatirDrops::PageObject

  def self.base_site=(base_site)
    @@base_site = base_site
  end

  def self.base_site
    if !defined?(@@base_site) && defined?(Watir::Rails)
      @@base_site = "http://#{Watir::Rails.host}:#{Watir::Rails.port}"
    end
    @@base_site ||= ''
  end

  def self.visit(*args)
    new.tap do |page|
      page.goto(*args)
      exception = Selenium::WebDriver::Error::WebDriverError
      message = "Expected to be on #{page.class}, but conditions not met"
      if page.page_verifiable?
        begin
          page.wait_until(&:on_page?)
        rescue Watir::Wait::TimeoutError
          raise exception, message
        end
      end
    end
  end

  def self.page_url(required: false)
    @require_url = required

    define_method("page_url") do |*args|
      "#{self.class.base_site}#{yield(*args)}"
    end
  end

  def on_page?
    exception = Selenium::WebDriver::Error::WebDriverError
    message = "Can not verify page without any requirements set"
    raise exception, message unless page_verifiable?

    if self.class.require_url && page_url.gsub("#{URI.parse(page_url).scheme}://", '') != browser.url.gsub("#{URI.parse(browser.url).scheme}://", '')
      return false
    end

    if self.respond_to?(:page_title) && browser.title != page_title
      return false
    end

    if !self.class.required_element_list.empty? && self.class.required_element_list.any? { |e| !send(e).present? }
      return false
    end

    true
  end

  def goto(*args)
    browser.goto page_url(*args)
  end

  def method_missing(method, *args, &block)
    if @browser.respond_to?(method) && method != :page_url
      @browser.send(method, *args, &block)
    else
      super
    end
  end

end
