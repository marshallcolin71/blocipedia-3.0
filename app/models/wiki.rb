class Wiki < ActiveRecord::Base
  belongs_to :user
<<<<<<< HEAD
=======
  validates :user, presence: true
>>>>>>> user-roles
end
