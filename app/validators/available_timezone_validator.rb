class AvailableTimezoneValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    unless value.blank?
      record.errors[field] << I18n.t('validators.available_timezone') unless ActiveSupport::TimeZone[value].present?
    end
  end
end
