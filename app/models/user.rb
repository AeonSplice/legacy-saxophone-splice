class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  attr_accessor :bypass_activation_email

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
    if: -> { new_record? || changes[:crypted_password] }

  validates :password_confirmation,
    presence: true,
    if: -> { new_record? || changes[:crypted_password] }

  ###################################
  ## Database Attribute Validation ##
  ###################################

  validates :username, :email,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :username,
    username_convention: true

  ####################
  ## Public Methods ##
  ####################

  # Return if current user is activated or not
  def activated?
    activation_state == 'active'
  end

  # Allow bypassing the activation email
  def send_activation_needed_email!
    super unless bypass_activation_email
  end

  # Prevent setting up activation if created as active
  def setup_activation
    super unless activation_state == 'active'
  end
end
