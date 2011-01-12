namespace :window_rails  do 
  desc 'Install required library items'
  task :install do
    require File.join(File.dirname(__FILE__), '..', '..', 'install.rb')
  end
end

