#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rem::Application.load_tasks

begin
  require 'gettext_i18n_rails/tasks'
rescue LoadError
  puts 'gettext_i18n_rails is not installed'
end
