task :merge_results do
  require 'simplecov'
  require 'open-uri'
  api_url = "https://circleci.com/api/v1.1/project/github/#{ENV['CIRCLE_PROJECT_USERNAME']}/#{ENV['CIRCLE_PROJECT_REPONAME']}/#{ENV['CIRCLE_BUILD_NUM']}/artifacts?circle-token=#{ENV['CIRCLE_TOKEN']}"
  artifacts = open(api_url)
  coverage_dir = '/tmp/coverage'
  SimpleCov.coverage_dir(coverage_dir)

  JSON.load(artifacts)
    .map { |artifact| JSON.load(open("#{artifact['url']}?circle-token=#{ENV['CIRCLE_TOKEN']}")) }
    .each_with_index do |resultset, i|
    resultset.each do |_, data|
      result = SimpleCov::Result.from_hash(['command', i].join => data)
      SimpleCov::ResultMerger.store_result(result)
    end
  end
end
