class User < ApplicationRecord
  rolify

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  attr_accessor :bypass_activation_email,
                :bypass_password

  ##################
  ## Associations ##
  ##################

  has_many :authentications, dependent: :destroy

  #######################
  ## Nested Attributes ##
  #######################

  accepts_nested_attributes_for :authentications

  ##################################
  ## Virtual Attribute Validation ##
  ##################################

  validates :password,
    confirmation: true,
    length: { minimum: 8 },
    if: -> { (new_record? && !bypass_password) || changes[:crypted_password] }

  validates :password_confirmation,
    presence: true,
    if: -> { (new_record? && !bypass_password) || changes[:crypted_password] }

  ###################################
  ## Database Attribute Validation ##
  ###################################

  validates :username, :email,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :locale, :timezone,
    presence: true

  validates :username,
    username_convention: true

  validates :email,
    email_convention: true

  validates :locale,
    available_locale: true

  validates :timezone,
    available_timezone: true

  #############
  ## Queries ##
  #############

  # Return if user can remove a given auth
  def can_remove_auth?(authentication)
    return false unless authentication.user == self
    return true if self.crypted_password.present?
    return true if self.authentications.count >= 2
    false
  end

  # Return if current user is activated or not
  def activated?
    activation_state == 'active'
  end

  def meta_present?
    # NOTE: Holy shit I'm mildly OCD
    return true if self.realname.present? or
                   self.nickname.present? or
                   self.bio.present?      or
                   self.location.present? or
                   self.website.present?  or
                  (self.locale.present?   && self.locale   != 'en' ) or
                  (self.timezone.present? && self.timezone != 'UTC')
    false
  end

  # Allow bypassing the activation email
  def send_activation_needed_email?
    return false if bypass_activation_email
    true
  end

  def language
    I18n.t('language', locale: self.locale)
  end

  ##############
  ## Commands ##
  ##############

  def sanitize_timezone
    if self.timezone.present? and not valid_timezone?(self.timezone)
      converted_timezone = timezone_from_offset(self.timezone)
      self.timezone = valid_timezone?(converted_timezone) ? converted_timezone : 'UTC'
    end
  end

  def sanitize_locale
    if self.locale.present? and not valid_locale?(self.locale)
      converted_locale = locale_without_country(self.locale)
      self.locale = valid_locale?(converted_locale) ? converted_locale : I18n.default_locale
    end
  end

  # Prevent setting up activation if created as active
  def setup_activation
    super unless activation_state == 'active'
  end
end
