brew 'rbenv'
brew 'ruby-build'

rbenv_config = node["rbenv"]

rbenv_config["rubies"].each do |version|
  execute "/usr/local/bin/rbenv install #{version}" do
    user node["current_user"]
    environment ({'HOME' => "/Users/#{node["current_user"]}"})

    not_if { File.exist? "/Users/#{node["current_user"]}/.rbenv/versions/#{version}" }
  end
end

execute "/usr/local/bin/rbenv global #{rbenv_config["global"]}" do
  not_if "/usr/local/bin/rbenv global | grep #{rbenv_config["global"]}"
end

%w(/etc/profile /etc/zshenv).each do |profile|
  execute "add rbenv setting to #{profile}" do
    command %{ test -e #{profile} && echo 'eval "$(/usr/local/bin/rbenv init -)"' >> #{profile} }
    not_if "grep 'rbenv init' #{profile}"
  end
end

rbenv_config["gems"].each do |version, gem_hashs|
  gem_hashs.each do |h|
    pkg = h["name"]
    execute "gem-install-#{pkg}-in-#{version}" do
      user node["current_user"]
      environment ({'HOME' => "/Users/#{node["current_user"]}", 'RBENV_VERSION' => version})
      command "gem install #{pkg}"

      not_if "RBENV_VERSION=#{version} gem list | grep '^#{pkg} ' "
    end
  end
end