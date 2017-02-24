module ApplicationHelper
  def show_errors(object, field_name, opts = {})
    if object.errors.any? && object.errors.messages[field_name].present?
      errors = object.errors.messages[field_name]
      render_prefix = !opts[:prefix].nil? ? (opts[:prefix] == true) : true
      field_name_str = render_prefix ? field_name.to_s.humanize + ' ' : ''
      content_tag :div, class: 'errors' do
        errors.reduce('') { |results, error| results << content_tag(:span, field_name_str + error) }.html_safe
      end
    end
  end

  def provider_icon(provider)
    if provider.downcase == 'microsoft'
      content_tag :div, nil, class: 'fa fa-windows'
    else
      content_tag :div, nil, class: "fa fa-#{provider.downcase}"
    end
  end

  def available_locale_pairs
    I18n.available_locales.map do |locale|
      [I18n.t('language', locale: locale), locale.to_s]
    end
  end
end
