require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
task :default => :test

desc 'Run tests (default)'
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.ruby_opts = ['-Itest', '-W0']
  t.libs << "lib" << "test"
  t.ruby_opts << '-rubygems' if defined? Gem
end
