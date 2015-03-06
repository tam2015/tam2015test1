# -*- encoding: utf-8 -*-
# stub: virtus 1.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "virtus"
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Piotr Solnica"]
  s.date = "2015-03-06"
  s.description = "Attributes on Steroids for Plain Old Ruby Objects"
  s.email = ["piotr.solnica@gmail.com"]
  s.extra_rdoc_files = ["LICENSE", "README.md", "TODO.md"]
  s.files = [".gitignore", ".pelusa.yml", ".rspec", ".ruby-gemset", ".ruby-version", ".travis.yml", ".yardopts", "CONTRIBUTING.md", "Changelog.md", "Gemfile", "Guardfile", "LICENSE", "README.md", "Rakefile", "TODO.md", "lib/virtus.rb", "lib/virtus/attribute.rb", "lib/virtus/attribute/accessor.rb", "lib/virtus/attribute/boolean.rb", "lib/virtus/attribute/builder.rb", "lib/virtus/attribute/coercer.rb", "lib/virtus/attribute/coercible.rb", "lib/virtus/attribute/collection.rb", "lib/virtus/attribute/default_value.rb", "lib/virtus/attribute/default_value/from_callable.rb", "lib/virtus/attribute/default_value/from_clonable.rb", "lib/virtus/attribute/default_value/from_symbol.rb", "lib/virtus/attribute/embedded_value.rb", "lib/virtus/attribute/hash.rb", "lib/virtus/attribute/lazy_default.rb", "lib/virtus/attribute/strict.rb", "lib/virtus/attribute_set.rb", "lib/virtus/builder.rb", "lib/virtus/builder/hook_context.rb", "lib/virtus/class_inclusions.rb", "lib/virtus/class_methods.rb", "lib/virtus/coercer.rb", "lib/virtus/configuration.rb", "lib/virtus/const_missing_extensions.rb", "lib/virtus/extensions.rb", "lib/virtus/instance_methods.rb", "lib/virtus/model.rb", "lib/virtus/module_extensions.rb", "lib/virtus/support/equalizer.rb", "lib/virtus/support/options.rb", "lib/virtus/support/type_lookup.rb", "lib/virtus/value_object.rb", "lib/virtus/version.rb", "spec/integration/building_module_spec.rb", "spec/integration/collection_member_coercion_spec.rb", "spec/integration/custom_attributes_spec.rb", "spec/integration/custom_collection_attributes_spec.rb", "spec/integration/default_values_spec.rb", "spec/integration/defining_attributes_spec.rb", "spec/integration/embedded_value_spec.rb", "spec/integration/extending_objects_spec.rb", "spec/integration/hash_attributes_coercion_spec.rb", "spec/integration/inheritance_spec.rb", "spec/integration/injectible_coercers_spec.rb", "spec/integration/mass_assignment_with_accessors_spec.rb", "spec/integration/overriding_virtus_spec.rb", "spec/integration/required_attributes_spec.rb", "spec/integration/struct_as_embedded_value_spec.rb", "spec/integration/using_modules_spec.rb", "spec/integration/value_object_with_custom_constructor_spec.rb", "spec/integration/virtus/instance_level_attributes_spec.rb", "spec/integration/virtus/value_object_spec.rb", "spec/shared/constants_helpers.rb", "spec/shared/freeze_method_behavior.rb", "spec/shared/idempotent_method_behaviour.rb", "spec/shared/options_class_method.rb", "spec/spec_helper.rb", "spec/unit/virtus/attribute/boolean/coerce_spec.rb", "spec/unit/virtus/attribute/boolean/value_coerced_predicate_spec.rb", "spec/unit/virtus/attribute/class_methods/build_spec.rb", "spec/unit/virtus/attribute/class_methods/coerce_spec.rb", "spec/unit/virtus/attribute/coerce_spec.rb", "spec/unit/virtus/attribute/coercible_predicate_spec.rb", "spec/unit/virtus/attribute/collection/class_methods/build_spec.rb", "spec/unit/virtus/attribute/collection/coerce_spec.rb", "spec/unit/virtus/attribute/custom_collection_spec.rb", "spec/unit/virtus/attribute/defined_spec.rb", "spec/unit/virtus/attribute/embedded_value/class_methods/build_spec.rb", "spec/unit/virtus/attribute/embedded_value/coerce_spec.rb", "spec/unit/virtus/attribute/get_spec.rb", "spec/unit/virtus/attribute/hash/class_methods/build_spec.rb", "spec/unit/virtus/attribute/hash/coerce_spec.rb", "spec/unit/virtus/attribute/lazy_predicate_spec.rb", "spec/unit/virtus/attribute/rename_spec.rb", "spec/unit/virtus/attribute/required_predicate_spec.rb", "spec/unit/virtus/attribute/set_default_value_spec.rb", "spec/unit/virtus/attribute/set_spec.rb", "spec/unit/virtus/attribute/value_coerced_predicate_spec.rb", "spec/unit/virtus/attribute_set/append_spec.rb", "spec/unit/virtus/attribute_set/define_reader_method_spec.rb", "spec/unit/virtus/attribute_set/define_writer_method_spec.rb", "spec/unit/virtus/attribute_set/each_spec.rb", "spec/unit/virtus/attribute_set/element_reference_spec.rb", "spec/unit/virtus/attribute_set/element_set_spec.rb", "spec/unit/virtus/attribute_set/merge_spec.rb", "spec/unit/virtus/attribute_set/reset_spec.rb", "spec/unit/virtus/attribute_spec.rb", "spec/unit/virtus/attributes_reader_spec.rb", "spec/unit/virtus/attributes_writer_spec.rb", "spec/unit/virtus/class_methods/finalize_spec.rb", "spec/unit/virtus/class_methods/new_spec.rb", "spec/unit/virtus/config_spec.rb", "spec/unit/virtus/element_reader_spec.rb", "spec/unit/virtus/element_writer_spec.rb", "spec/unit/virtus/freeze_spec.rb", "spec/unit/virtus/model_spec.rb", "spec/unit/virtus/module_spec.rb", "spec/unit/virtus/set_default_attributes_spec.rb", "spec/unit/virtus/value_object_spec.rb", "virtus.gemspec"]
  s.homepage = "https://github.com/solnic/virtus"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Attributes on Steroids for Plain Old Ruby Objects"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<descendants_tracker>, [">= 0.0.3", "~> 0.0"])
      s.add_runtime_dependency(%q<equalizer>, [">= 0.0.9", "~> 0.0"])
      s.add_runtime_dependency(%q<coercible>, ["~> 1.0"])
      s.add_runtime_dependency(%q<axiom-types>, ["~> 0.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<descendants_tracker>, [">= 0.0.3", "~> 0.0"])
      s.add_dependency(%q<equalizer>, [">= 0.0.9", "~> 0.0"])
      s.add_dependency(%q<coercible>, ["~> 1.0"])
      s.add_dependency(%q<axiom-types>, ["~> 0.1"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<descendants_tracker>, [">= 0.0.3", "~> 0.0"])
    s.add_dependency(%q<equalizer>, [">= 0.0.9", "~> 0.0"])
    s.add_dependency(%q<coercible>, ["~> 1.0"])
    s.add_dependency(%q<axiom-types>, ["~> 0.1"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
