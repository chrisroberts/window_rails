require 'window_rails/version'

def install_javascripts
  raise 'Unknown Rails path' unless defined? RAILS_ROOT
  FileUtils.cp_r(File.join(File.dirname(__FILE__), 'files', 'javascripts', File::SEPARATOR, '.'), File.join(RAILS_ROOT, 'public', 'javascripts', 'window_rails'))
end

def install_themes
  raise 'Unknown Rails path' unless defined? RAILS_ROOT
  FileUtils.cp_r(File.join(File.dirname(__FILE__), 'files', 'themes'), File.join(RAILS_ROOT, 'public'))
end

def install_version
  f = File.open(File.join(RAILS_ROOT, 'public', 'javascripts', 'window_rails', 'version'), 'w')
  f.puts WindowRails::VERSION
  f.close
end

def install_all
  install_javascripts
  install_themes
  install_version
end

## Place version file and check for it. install if not found.
if(File.exists?(File.join(RAILS_ROOT, 'public', 'javascripts', 'window_rails', 'version')))
  check = File.read(File.join(RAILS_ROOT, 'public', 'javascripts', 'window_rails', 'version')).strip
  install_all unless check == WindowRails::VERSION
else
  install_all
end