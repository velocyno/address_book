unless Rails.env.production?

  require 'rspec/core/rake_task'

  ENV['PARALLEL_SPLIT_TEST_PROCESSES'] = '10'
  @success = true

  task :test_parallel_api do
    ENV['BUILD_TAG'] = "Parallel with API - #{Time.now.to_i}"
    junit = 'junit_reports/test'
    FileUtils.mkpath(junit[/^[^\/]+/])
    begin
      @result = system "parallel_split_test spec/5parallel_api_spec.rb --format d --out #{junit}.xml"
    ensure
      @success &= @result
    end
  end
end