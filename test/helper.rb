require "bundler"
Bundler.setup

require 'minitest/autorun'
require 'minitest/pride'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'gaga'

TMP_DIR = '/tmp/gaga_test'
TMP_BARE = '/tmp/gaga_test_bare.git'

def tmp_dir
  TMP_DIR
end

def tmp_bare
  TMP_BARE
end

def remove_tmpdir!(passed_dir = nil)
  FileUtils.rm_rf(passed_dir || tmp_dir)
end

