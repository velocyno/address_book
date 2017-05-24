module Test
  class AddressBook

    if ENV['NO_API'] == 'true'
      include PageSupport
    else
      include APISupport
    end

    def browser
      WatirDrops::PageObject.browser
    end

  end
end