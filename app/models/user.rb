class User < ApplicationRecord
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

  ####################
  ## Public Methods ##
  ####################

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

  # Prevent setting up activation if created as active
  def setup_activation
    super unless activation_state == 'active'
  end
end
