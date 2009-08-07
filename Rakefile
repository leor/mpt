require "echoe"
require "rake/testtask"
require "rcov/rcovtask"
require 'rake/rdoctask'

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "MPT - Monkey Patching Toolkit"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.rdoc_files.include('README', 'CHANGELOG')
  rdoc.rdoc_files.include('lib/mpt.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

namespace :test do
  namespace :coverage do
    task :clean do
      rm_f "coverage.data"
    end
  end
  
  task :coverage => "test:coverage:clean"
  
  Rcov::RcovTask.new(:coverage) do |t|
    t.libs << "test"
    t.test_files = FileList["test/**/*_test.rb"]
    t.output_dir = "test/coverage"
    t.verbose = true
    t.rcov_opts << '--aggregate coverage.data'
  end
  
end

Echoe.new( "mpt" ) do |p|
	p.author = "Anatoly Lapshin"
	p.summary = "Monkey Patching Toolkit"
	p.runtime_dependencies = ['activesupport', 'uuid']
	p.development_dependencies = []
	p.need_tar_gz = false
	p.retain_gemspec = true
	p.gemspec_name = 'mpt.gemspec'
	p.clean_pattern.push 'lib/*-*'
end