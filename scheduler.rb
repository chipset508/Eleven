require './config/environment.rb'

puts "Before GithubComment count: #{GithubComment.count}"
if GithubComment.count > 4000
  GithubComment.order('id ASC').limit(500).destroy_all
end
puts "After GithubComment count: #{GithubComment.count}"

puts "="*100

puts "Before PullRequest count: #{PullRequest.count}"
if PullRequest.count > 5000
  PullRequest.order('id asc').limit(1000).destroy_all
end
puts "After PullRequest count: #{PullRequest.count}"
