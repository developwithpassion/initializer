require 'bundler'
Bundler.setup

lib_dir = File.expand_path('lib')
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'initializer'