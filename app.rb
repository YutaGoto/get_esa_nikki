require "esa"
require 'date'

class Hash
  def method_missing(m)
    fetch(m) { fetch(m.to_s) { super } }
  end
end

access_token = ENV['ACCESS_TOKEN']
current_team = ENV['CURRENT_TEAM']

if access_token.nil? || current_team.nil?
  raise 'ACCESS_TOKEN or CURRENT_TEAM is not set'
end

client = Esa::Client.new(access_token:, current_team:)

current_year = Date.today.year

(1..12).each do |m|
  arr = []
  puts m.to_s.rjust(2, '0')
  File.open("./nikki/nikki#{m}.md", "w") do |f|
    (1..(Date.new(current_year, m, -1).day)).each do |d|
      puts d.to_s.rjust(2, '0')
      body = client.posts(q: "in:\"日記/#{current_year}/#{m.to_s.rjust(2, '0')}\" name:\"#{d.to_s.rjust(2, '0')}\"").body
      sleep(10)
      body.posts.each do |post|
        arr << post.body_md
      end
    end
    f.print arr.join("\n")
    sleep(100)
  end
end
