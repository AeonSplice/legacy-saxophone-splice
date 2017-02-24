class AvailableLocaleValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    unless value.blank?
      record.errors[field] << I18n.t('validators.available_locale') unless I18n.available_locales.include?(value.to_sym)
    end
  end
end
