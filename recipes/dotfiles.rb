urls = {
  ".zshrc"     => "https://raw.github.com/slightair/dotfiles/master/.zshrc",
}

urls.each do |dotfile, url|
  remote_file "#{ENV['HOME']}/#{dotfile}" do
    source url
    action :create_if_missing
    owner node['current_user']
    mode  0644
  end
end