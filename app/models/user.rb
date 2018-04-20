class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wikis, dependent: :destroy
  has_many :collaborators

  enum role: [:standard, :premium, :admin]

  after_initialize :initialize_role

  def init
     self.role ||= :standard
  end

  def self.going_public(user)
    @wikis = user.wikis.where(private: true)
    @wikis.each do |wiki|
      wiki.update_attribute(private: false)
    end
  end

private

def initialize_role
  self.role ||= :standard
end

end
