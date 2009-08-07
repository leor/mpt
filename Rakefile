require "echoe"

Echoe.new( "mpt" ) do |p|
  p.author =          ["Anatoly Lapshin", "Ilya Vesov"]
  p.summary =         "Monkey Patching Toolkit"
  p.email =           "holywarez@gmail.com"
  p.url =             "http://github.com/holywarez/mpt"

  p.runtime_dependencies = ['activesupport', 'uuid']
  p.development_dependencies = []
  
  p.need_tar_gz =     false
  p.retain_gemspec =  true
  p.gemspec_name =    'mpt.gemspec'
  p.test_pattern =    ["test/**/*_test.rb"]

  p.clean_pattern.push 'lib/*-*'
  p.has_rdoc =        true
  p.rdoc_pattern =    ["README", "CHANGELOG", "lib/**/*.rb"]
  p.rdoc_options <<   "-c utf-8"
  p.ignore_pattern =  [".gitignore", "doc", "examples", ".idea", "coverage.data", "*.bat"]
end