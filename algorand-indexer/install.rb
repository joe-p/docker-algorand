require 'json'
require 'net/http'

def run(run_str)
  system(run_str, exception: true)
end

branch = ENV['branch'].to_s
version = ENV['version'].to_s

if branch.empty?
  if version == 'latest'
    uri = URI('https://api.github.com/repos/algorand/indexer/releases')
    releases = JSON.parse(Net::HTTP.get(uri))
    latest_release = releases[0]
    version = latest_release['tag_name']
  end

  run "wget https://github.com/algorand/indexer/releases/download/#{version}/algorand-indexer_#{version}_amd64.deb"
  run "apt-get install -y ./algorand-indexer_#{version}_amd64.deb"
else
  run "git clone -b #{branch} https://github.com/algorand/indexer.git"
  Dir.chdir('indexer') { run 'make' }
end
