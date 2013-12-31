gem_package('plist')

plist_file = "#{ENV['HOME']}/Library/Preferences/com.apple.Terminal.plist"
xml_plist = `plutil -convert xml1 -o - #{plist_file}`
settings = Plist::parse_xml(xml_plist)

theme_installed = settings['Window Settings'].keys.include? 'IR_Black'

theme_file = 'IR_Black.terminal'
remote_uri = 'http://blog.toddwerth.com/entry_files/13/IR_Black.terminal.zip'
file_checksum = '8fc50240e4bb6e8e659833c17f586c79179032db869fb2a64be16356466ad4b2'

remote_file "/tmp/#{theme_file}.zip" do
  source "#{remote_uri}"
  checksum "#{file_checksum}"

  not_if { theme_installed }
end

script "install IR_Black theme" do
  interpreter "bash"
  code <<-EOS
    unzip /tmp/#{theme_file}.zip -d /tmp
    open /tmp/#{theme_file}
  EOS

  not_if { theme_installed }
end

osx_defaults "set default window settings" do
  domain "#{ENV['HOME']}/Library/Preferences/com.apple.Terminal"
  key 'Default Window Settings'
  string 'IR_Black'
end