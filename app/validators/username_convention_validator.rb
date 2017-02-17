class UsernameConventionValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    unless value.blank?
      record.errors[field] << t('validators.username_convention.alphanumeric') unless value =~ /^[[:alnum:]_-]+$/
      record.errors[field] << t('validators.username_convention.start_with_letter') unless value[0] =~ /[A-Za-z]/
      record.errors[field] << t('validators.username_convention.illegal_characters') unless value.ascii_only?
    end
  end
end
