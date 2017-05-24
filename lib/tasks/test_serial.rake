unless Rails.env.production?

  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:test_serial) do |c|
    ENV['BUILD_TAG'] = "Serial - #{Time.now.to_i}"
    c.rspec_opts = "--pattern spec/3page_objects_spec.rb"
  end
end
