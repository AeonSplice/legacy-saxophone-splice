class Authentication < ApplicationRecord
  ##################
  ## Associations ##
  ##################

  belongs_to :user

  ####################################
  ## Database Attribute Validations ##
  ####################################

  validates :user, :uid, :provider,
    presence: true

  validates :uid, uniqueness: { scope: :provider }
end
