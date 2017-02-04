class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password,
    confirmation: true,
    length: { minimum: 3 },
    if: -> { new_record? || changes[:crypted_password] }

  validates :password_confirmation,
    presence: true,
    if: -> { new_record? || changes[:crypted_password] }

  validates :username, :email,
    presence: true

  validates :email,
    uniqueness: { case_sensitive: false }

  def activated?
    activation_state == 'active'
  end
end
