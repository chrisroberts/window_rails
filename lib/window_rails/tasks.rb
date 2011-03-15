require 'fileutils'

namespace :window_rails  do

  desc 'Install window_rails'
  task :install do
    FileUtils.mkdir_p(File.join(Rails.root, 'public', 'window_rails'))
    Rake::Task['window_rails:install_javascripts'].invoke
    Rake::Task['window_rails:install_stylesheets'].invoke
    Rake::Task['window_rails:install_assets'].invoke
    Rake::Task['window_rails:install_version'].invoke
    puts '*' * 50
    puts 'WindowRails installation is complete.'
    puts 'NOTE: Please refer to README file for any additional setup.'
    puts '*' * 50
  end

  task :upgrade do
    Rake::Task['window_rails:install_javascripts'].invoke
    Rake::Task['window_rails:install_stylesheets'].invoke
    Rake::Task['window_rails:install_assets'].invoke
    puts 'WindowRails files have been updated to most current version'
  end

  task :install_javascripts do
    install_items('javascripts')
  end

  task :install_stylesheets do
    install_items('stylesheets')
  end

  task :install_assets do
    install_items('images')
  end

  task :install_version do
    f = File.open(File.join(Rails.root, 'public', 'window_rails', 'version'), 'w')
    f.write WindowRails::VERSION
    f.close
    puts 'Version file written'
  end

  desc 'Output current version information'
  task :version do
    asset_version = nil
    if(File.exists?(File.join(Rails.root, 'public', 'window_rails', 'version')))
      asset_version = File.read(File.join(Rails.root, 'public', 'window_rails', 'version')).strip
    end
    puts "Current WindowRails version: #{WindowRails::VERSION}"
    puts "Current WindowRails assets version: #{asset_version}"
    if(WindowRails::VERSION != asset_version.to_s)
      puts "WARNING #{'*' * 50}"
      puts 'WindowRails assets within project are out of date'
      puts 'Please run: rake window_rails:upgrade'
      puts "WARNING #{'*' * 50}"
    end
  end
end

def install_items(item)
  FileUtils.mkdir_p(File.join(Rails.root, 'public', 'window_rails', item))
  FileUtils.cp_r(
    File.join(File.dirname(__FILE__), 'files', item, File::SEPARATOR, '.'), 
    File.join(Rails.root, 'public', 'window_rails', item)
  )
  puts "#{item.titleize} files installed."
end

