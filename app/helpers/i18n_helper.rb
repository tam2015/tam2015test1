module I18nHelper

  # Translate Provider
  def translate_provider(provider_name)
    I18n.t ".nane", scope: "controllers.providers.#{provider_name}", default: provider_name.titleize
  end
  alias :t_provider :translate_provider

  # Translate Model
  # Defaults:
  #   pluralize = true
  #   downcase  = false
  def t_model(record, pluralize=true, downcase=false)
    options = { }

    options[:count] = 2 if pluralize

    string = record.model_name.human options
    string = string.downcase  if downcase
    string
  end

  # Alias to t_model with downcase is default
  # Defaults:
  #   downcase  = false
  def down_model(record, *args)
    # set downcase=true
    args[1] = true
    t_model(record, *args)
  end

  def translate_count_result records
    model_name = records.model_name.human
    model_name = model_name.pluralize if records.count > 1
    namespace = records.name.tableize

    lookups = ["#{namespace}.counted", "defaults.counted"].map(&:to_sym)

    I18n.t lookups.shift, scope: "helpers.results", default: lookups, count: records.count, model: model_name.downcase
  end

  # Button content translated
  def translate_button_content action, record, *args#, icon, string_class
    options = args[0]
    label_class = options[:label_class] || "string"
    icon        = options[:icon] || ""

    _label = translate_helper :actions, action, record
    _title = translate_helper :titles, action, record

    # make icon
    unless icon.blank?
      icon_class  = options[:icons_class] || "fa fa-#{icon}"
      icon = content_tag(:i, nil, class: icon_class, title: _title )
    end

    # make text
    string = content_tag(:span, _label, class: "string #{label_class}")

    [icon, string].join("\n").html_safe
  end

  def translate_helper namespace, action, record
    model_name      = record.model_name.human.downcase
    model_tableize  = record.model_name.collection

    lookups = []
    lookups << [ model_tableize, namespace, action ].join(".").to_sym
    lookups << [ namespace, action ].join(".").to_sym

    # lookups = [model_tableize, "" ].map do |look|
    #   [look, namespace, action ].join(".").to_sym
    # end

    I18n.t(lookups.shift, scope: "helpers", default: lookups , model: model_name)
  end

  # Lookup translations for the given namespace using I18n, based on object name,
  # actual action and attribute name. Lookup priority as follows:
    #
    #   simple_form.{namespace}.{model}.{action}.{attribute}
    #   simple_form.{namespace}.{model}.{attribute}
    #   simple_form.{namespace}.defaults.{attribute}
    #
    #  Namespace is used for :labels and :hints.
    #
    #  Model is the actual object name, for a @user object you'll have :user.
    #  Action is the action being rendered, usually :new or :edit.
    #  And attribute is the attribute itself, :name for example.
    #
    #  The lookup for nested attributes is also done in a nested format using
    #  both model and nested object names, such as follow:
    #
    #   simple_form.{namespace}.{model}.{nested}.{action}.{attribute}
    #   simple_form.{namespace}.{model}.{nested}.{attribute}
    #   simple_form.{namespace}.{nested}.{action}.{attribute}
    #   simple_form.{namespace}.{nested}.{attribute}
    #   simple_form.{namespace}.defaults.{attribute}
    #
    #  Example:
    #
    #    simple_form:
    #      labels:
    #        user:
    #          new:
    #            email: 'E-mail para efetuar o sign in.'
    #          edit:
    #            email: 'E-mail.'
    #
    #  Take a look at our locale example file.
  def translate_from_namespace(namespace, attribute_name, record, default = '')
    model_name = record.model_name
    attribute_name = attribute_name.to_s unless attribute_name.kind_of? String
    lookups    = []

    # variations
    [:i18n_key, :singular].each do |variation|
      lookups << [model_name.send(variation).to_s, attribute_name ].join(".").to_sym
    end
    lookups << :"defaults.#{attribute_name}"

    t(lookups.shift, scope: :"simple_form.#{namespace}", default: lookups).presence
  end
  alias :t_namespace :translate_from_namespace

  def translate_placeholder(*args)
    translate_from_namespace(:placeholders, *args)
  end
  alias :t_placeholder :translate_placeholder

  def translate_label(*args)
    translate_from_namespace(:labels, *args)
  end
  alias :t_label :translate_label
end
