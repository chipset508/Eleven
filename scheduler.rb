require './config/environment.rb'

puts "Before GithubComment count: #{GithubComment.count}"
GithubComment.destroy_all
puts "After GithubComment count: #{GithubComment.count}"
