# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mpt}
  s.version = "0.1.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anatoly Lapshin"]
  s.date = %q{2009-07-31}
  s.description = %q{Monkey Patching Toolkit}
  s.email = %q{}
  s.extra_rdoc_files = ["CHANGELOG", "lib/event.rb", "lib/mpt.rb", "lib/system.rb", "lib/wrap.rb", "LICENSE", "README"]
  s.files = ["CHANGELOG", "examples/call_experiment.rb", "examples/declarations.rb", "examples/instance_eval_with_args.rb", "examples/ordered_subscribers.rb", "examples/run_experiments.rb", "examples/unordered_subscribers.rb", "examples/wrap_method_experiment.rb", "install_gem.bat", "lib/event.rb", "lib/mpt.rb", "lib/system.rb", "lib/wrap.rb", "LICENSE", "Manifest", "mpt.gemspec", "Rakefile", "README", "run_examples.bat"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Mpt", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mpt}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Monkey Patching Toolkit}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<uuid>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<uuid>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<uuid>, [">= 0"])
  end
end
