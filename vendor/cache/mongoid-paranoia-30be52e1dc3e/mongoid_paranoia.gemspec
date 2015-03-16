# -*- encoding: utf-8 -*-
# stub: mongoid_paranoia 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid_paranoia"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Durran Jordan", "Josef \u{160}im\u{e1}nek"]
  s.date = "2015-03-14"
  s.description = "There may be times when you don't want documents to actually get deleted from the database, but \"flagged\" as deleted. Mongoid provides a Paranoia module to give you just that."
  s.email = ["durran@gmail.com", "retro@ballgag.cz"]
  s.files = ["LICENSE", "README.md", "lib/mongoid", "lib/mongoid-paranoia.rb", "lib/mongoid/paranoia", "lib/mongoid/paranoia.rb", "lib/mongoid/paranoia/monkey_patches.rb", "lib/mongoid/paranoia/version.rb", "lib/mongoid_paranoia.rb", "perf/scope.rb", "spec/app", "spec/app/models", "spec/app/models/address.rb", "spec/app/models/appointment.rb", "spec/app/models/author.rb", "spec/app/models/fish.rb", "spec/app/models/paranoid_phone.rb", "spec/app/models/paranoid_post.rb", "spec/app/models/person.rb", "spec/app/models/phone.rb", "spec/app/models/relations.rb", "spec/app/models/tag.rb", "spec/app/models/title.rb", "spec/mongoid", "spec/mongoid/document_spec.rb", "spec/mongoid/nested_attributes_spec.rb", "spec/mongoid/paranoia_spec.rb", "spec/mongoid/scoping_spec.rb", "spec/mongoid/validatable", "spec/mongoid/validatable/uniqueness_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://github.com/simi/mongoid-paranoia"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Paranoid documents"
  s.test_files = ["perf/scope.rb", "spec/app", "spec/app/models", "spec/app/models/address.rb", "spec/app/models/appointment.rb", "spec/app/models/author.rb", "spec/app/models/fish.rb", "spec/app/models/paranoid_phone.rb", "spec/app/models/paranoid_post.rb", "spec/app/models/person.rb", "spec/app/models/phone.rb", "spec/app/models/relations.rb", "spec/app/models/tag.rb", "spec/app/models/title.rb", "spec/mongoid", "spec/mongoid/document_spec.rb", "spec/mongoid/nested_attributes_spec.rb", "spec/mongoid/paranoia_spec.rb", "spec/mongoid/scoping_spec.rb", "spec/mongoid/validatable", "spec/mongoid/validatable/uniqueness_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, ["> 3"])
    else
      s.add_dependency(%q<mongoid>, ["> 3"])
    end
  else
    s.add_dependency(%q<mongoid>, ["> 3"])
  end
end
