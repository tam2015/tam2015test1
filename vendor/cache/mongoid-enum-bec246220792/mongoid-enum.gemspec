# -*- encoding: utf-8 -*-
# stub: mongoid-enum 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid-enum"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nicholas Bruning"]
  s.date = "2015-03-06"
  s.description = "Heavily inspired by DDH's ActiveRecord::Enum, this little library is there to help you cut down the cruft in your models and make the world a happier place at the same time."
  s.email = ["nicholas@bruning.com.au"]
  s.files = [".autotest", ".gitignore", ".rspec", ".travis.yml", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "lib/mongoid/enum.rb", "lib/mongoid/enum/validators/multiple_validator.rb", "lib/mongoid/enum/version.rb", "mongoid-enum.gemspec", "spec/mongoid/enum/validators/multiple_validator_spec.rb", "spec/mongoid/enum_spec.rb", "spec/spec_helper.rb", "spec/support/mongoid.yml"]
  s.homepage = "https://github.com/thetron/mongoid-enum"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Sweet enum sugar for your Mongoid documents"
  s.test_files = ["spec/mongoid/enum/validators/multiple_validator_spec.rb", "spec/mongoid/enum_spec.rb", "spec/spec_helper.rb", "spec/support/mongoid.yml"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, ["< 4.1", "> 3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.0.3"])
      s.add_development_dependency(%q<database_cleaner>, ["~> 1.2.0"])
      s.add_development_dependency(%q<mongoid-rspec>, ["~> 1.5.1"])
    else
      s.add_dependency(%q<mongoid>, ["< 4.1", "> 3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.0.3"])
      s.add_dependency(%q<database_cleaner>, ["~> 1.2.0"])
      s.add_dependency(%q<mongoid-rspec>, ["~> 1.5.1"])
    end
  else
    s.add_dependency(%q<mongoid>, ["< 4.1", "> 3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.0.3"])
    s.add_dependency(%q<database_cleaner>, ["~> 1.2.0"])
    s.add_dependency(%q<mongoid-rspec>, ["~> 1.5.1"])
  end
end
