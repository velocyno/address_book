unless Rails.env.production?

  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:test_serial) do |c|
    c.rspec_opts = "--pattern spec/3page_objects_spec.rb"
  end
end
