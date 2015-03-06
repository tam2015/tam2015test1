# -*- encoding: utf-8 -*-
# stub: surus 0.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "surus"
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jack Christensen"]
  s.date = "2015-03-06"
  s.description = "Surus accelerates ActiveRecord with PostgreSQL specific types and\n                    functionality. It enables indexed searching of serialized arrays and hashes.\n                    It also can control PostgreSQL synchronous commit behavior. By relaxing\n                    PostgreSQL's durability guarantee, transaction commit rate can be increased by\n                    50% or more. "
  s.email = ["jack@jackchristensen.com"]
  s.files = [".gitignore", ".rspec", "CHANGELOG.md", "Gemfile", "Guardfile", "LICENSE", "README.md", "Rakefile", "bench/benchmark_helper.rb", "bench/database.yml", "bench/database_structure.sql", "bench/hstore_find.rb", "bench/json_generation.rb", "bench/synchronous_commit.rb", "lib/generators/surus/hstore/install_generator.rb", "lib/generators/surus/hstore/templates/install_hstore.rb", "lib/surus.rb", "lib/surus/array/scope.rb", "lib/surus/hstore/scope.rb", "lib/surus/hstore/serializer.rb", "lib/surus/json/array_agg_query.rb", "lib/surus/json/association_scope_builder.rb", "lib/surus/json/belongs_to_scope_builder.rb", "lib/surus/json/has_and_belongs_to_many_scope_builder.rb", "lib/surus/json/has_many_scope_builder.rb", "lib/surus/json/model.rb", "lib/surus/json/query.rb", "lib/surus/json/row_query.rb", "lib/surus/synchronous_commit/connection.rb", "lib/surus/synchronous_commit/model.rb", "lib/surus/version.rb", "spec/array/scope_spec.rb", "spec/database.yml", "spec/database_structure.sql", "spec/factories.rb", "spec/hstore/scope_spec.rb", "spec/hstore/serializer_spec.rb", "spec/json/json_spec.rb", "spec/spec_helper.rb", "spec/synchronous_commit/connection_spec.rb", "spec/synchronous_commit/model_spec.rb", "surus.gemspec", "tmp/rspec_guard_result"]
  s.homepage = "https://github.com/JackC/surus"
  s.licenses = ["MIT"]
  s.rubyforge_project = ""
  s.rubygems_version = "2.2.2"
  s.summary = "PostgreSQL Acceleration for ActiveRecord"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 4.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
      s.add_development_dependency(%q<guard>, [">= 0.10.0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0.6.0"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
      s.add_development_dependency(%q<oj>, ["~> 2.0.2"])
      s.add_development_dependency(%q<pg>, [">= 0"])
      s.add_development_dependency(%q<pry>, ["~> 0.9.11"])
      s.add_development_dependency(%q<factory_girl>, ["~> 4.2.0"])
      s.add_development_dependency(%q<faker>, ["~> 1.1.2"])
    else
      s.add_dependency(%q<activerecord>, ["~> 4.0"])
      s.add_dependency(%q<rspec>, ["~> 2.12.0"])
      s.add_dependency(%q<guard>, [">= 0.10.0"])
      s.add_dependency(%q<guard-rspec>, [">= 0.6.0"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
      s.add_dependency(%q<oj>, ["~> 2.0.2"])
      s.add_dependency(%q<pg>, [">= 0"])
      s.add_dependency(%q<pry>, ["~> 0.9.11"])
      s.add_dependency(%q<factory_girl>, ["~> 4.2.0"])
      s.add_dependency(%q<faker>, ["~> 1.1.2"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 4.0"])
    s.add_dependency(%q<rspec>, ["~> 2.12.0"])
    s.add_dependency(%q<guard>, [">= 0.10.0"])
    s.add_dependency(%q<guard-rspec>, [">= 0.6.0"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
    s.add_dependency(%q<oj>, ["~> 2.0.2"])
    s.add_dependency(%q<pg>, [">= 0"])
    s.add_dependency(%q<pry>, ["~> 0.9.11"])
    s.add_dependency(%q<factory_girl>, ["~> 4.2.0"])
    s.add_dependency(%q<faker>, ["~> 1.1.2"])
  end
end
