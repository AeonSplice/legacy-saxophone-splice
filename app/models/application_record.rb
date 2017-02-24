class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def valid_timezone?(timezone)
    return false unless timezone.present?
    return ActiveSupport::TimeZone[timezone].present?
  end

  def valid_locale?(locale)
    return false unless locale.present?
    I18n.available_locales.include?(locale.to_sym)
  end

  def timezone_from_offset(offset)
    return nil if offset.to_i == 0 # invalid or no offset, do nothing
    ActiveSupport::TimeZone.new(offset.to_i).try(:name) # returns timezone name or nil if int not valid offset
  end

  def locale_without_country(locale)
    locale_underscore = locale.to_s.split('_')
    locale_hyphen = locale.to_s.split('-')
    language = nil
    if locale_underscore.count == 2
      language = locale_underscore.first
    elsif locale_hyphen.count == 2
      language = locale_hyphen.first
    end
    valid_locale?(language) ? language : nil
  end

  # NOTE: Reversing timezone abbreviations doesn't work. (ET != EST, multiple CST zones...)
  # def timezone_from_abbreviation(abbr)
  #   ActiveSupport::TimeZone.all.map do |zone|
  #     byebug if zone.name == 'Eastern Time (US & Canada)'
  #     return zone.name if Time.now.in_time_zone(zone).strftime('%Z') == abbr
  #   end
  #   return nil
  # end
end
