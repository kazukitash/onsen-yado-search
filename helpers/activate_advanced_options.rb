def activate_advanced_options query, params
  settings.advanced_options.elements.each("AdvancedOptions/Option") do |option|
    name = option.attributes["name"]
    query[name] = 1 if params[name].to_i == 1
  end
end
