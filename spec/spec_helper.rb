require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'ramesh'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow: "codeclimate.com")

def fixture_path(name)
  File.expand_path(File.join("..", "fixtures", name), __FILE__)
end
