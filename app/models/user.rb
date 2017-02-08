class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :bypass_activation_email

  validates :password,
    confirmation: true,
    length: { minimum: 8 },
    if: -> { new_record? || changes[:crypted_password] }

  validates :password_confirmation,
    presence: true,
    if: -> { new_record? || changes[:crypted_password] }

  validates :username, :email,
    presence: true

  validates :username,
    username_convention: true

  validates :username, :email,
    uniqueness: { case_sensitive: false }

  # Return if current user is activated or not
  def activated?
    activation_state == 'active'
  end

  # Allow bypassing the activation email
  def send_activation_needed_email!
    super unless bypass_activation_email
  end
end
