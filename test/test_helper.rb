$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "hop_timer"

require "minitest/autorun"

require "minitest/reporters"
Minitest::Reporters.use!
