# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'pry'
require 'nac'
require 'minitest/autorun'
require 'minitest/reporters'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
