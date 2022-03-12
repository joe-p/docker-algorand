def run(run_str)
  system(run_str, exception: true)
end

# import env variables as strings (so nil is '')
branch = ENV['branch'].to_s
channel = ENV['channel'].to_s

if branch.empty?
  run 'wget https://raw.githubusercontent.com/algorand/go-algorand-doc/master/downloads/installers/update.sh'
  run 'chmod +x update.sh'
  run "./update.sh -i -c #{channel} -p /algo_bin/ -d /public_node -n"
else
  run "git clone -b #{branch} https://github.com/algorand/go-algorand.git"

  Dir.chdir('go-algorand') do
    run './scripts/configure_dev.sh'
    run './scripts/buildtools/install_buildtools.sh'

    run 'make install'

    # copy all algorand binaries from /go/bin/ to /algo_bin/
    Dir.glob('./cmd/*').each do |cmd_dir|
      binary = "/go/bin/#{File.basename(cmd_dir)}"
      run "cp #{binary} /algo_bin/" if File.exist? binary
    end
  end

  run 'mv ~/.algorand /public_node'
end
