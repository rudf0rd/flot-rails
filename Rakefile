# -*- coding: utf-8 -*-
# -*- ruby -*-

# require 'rubygems'
# require "bundler/gem_tasks"
require 'tempfile'

desc "Pull latest flot-version"
task :update_flot do
  path = RUBY_PLATFORM =~ /(mswin|mingw)/ ? "C:\\TEMP\\flot" : "/tmp/flot"
  
  sh "rm #{path} -rf"
  sh "mkdir #{path}"
  sh "git clone --depth 1 https://github.com/flot/flot.git #{path}"
  
  sh "cp #{File.join(path, '*.js')} ./vendor/assets/javascripts/"
  sh "cp #{File.join(path, 'LICENSE.txt')} ./LICENSE.FLOT.txt"
  
  puts "git commit LICENSE.FLOT.txt ./vendor/assets/javascripts/* -m 'flot-update #{Time.now.strftime("%Y-%m-%d")}'"
end
