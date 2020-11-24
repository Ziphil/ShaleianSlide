# coding: utf-8


require 'bundler/setup'
Bundler.require

include REXML
include Zenithal

BASE_PATH = File.expand_path("..", File.dirname($0)).encode("utf-8")

Kernel.load(File.join(BASE_PATH, "converter/utility.rb"))
Encoding.default_external = "UTF-8"
$stdout.sync = true


whole_converter = Slide::WholeSlideConverter.new(ARGV)
whole_converter.execute