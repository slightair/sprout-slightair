execute "install nodebrew" do
  command "su #{node["current_user"]} -l -c 'curl -L git.io/nodebrew | perl - setup'"
  not_if { File.exists?("#{ENV['HOME']}/.nodebrew") }
end