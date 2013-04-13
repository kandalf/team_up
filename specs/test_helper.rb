require 'minitest/spec'
require 'minitest/autorun'
require File.dirname(__FILE__) + '/../team_up'

Ohm.connect(:url => 'redis://localhost:6379/team_up_test')
