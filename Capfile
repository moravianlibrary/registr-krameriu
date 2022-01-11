require "capistrano/setup"
require "capistrano/deploy"
require 'capistrano/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.5.3'

require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/passenger'

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
