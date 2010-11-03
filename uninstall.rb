require 'fileutils'

if(defined? RAILS_ROOT)
  Dir.new(File.join(File.dirname(__FILE__), 'files', 'javascripts')).each do |name|
    next if name[0,1] == '.'
    FileUtils.rm_rf(RAILS_ROOT, 'public', 'javascripts', name))
  end
  FileUtils.rm_rf(RAILS_ROOT, 'public', 'themes'))
end