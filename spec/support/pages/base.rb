class BasePage < WatirDrops::PageObject

  def self.base_site=(base_site)
    @@base_site = base_site
  end

  def self.base_site
    @@base_site ||= ''
  end

  def self.visit(*args)
    new.tap do |page|
      page.goto(*args)
      exception = Selenium::WebDriver::Error::WebDriverError
      message = "Expected to be on #{page.class}, but conditions not met"
      raise exception, message if page.page_verifiable? && !page.on_page?
    end
  end

  def self.page_url(required: false)
    @require_url = required

    define_method("page_url") do |*args|
      "#{self.class.base_site}#{yield(*args)}"
    end
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
