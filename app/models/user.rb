class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wikis, dependent: :destroy

  after_initialize { self.role ||= :standard }

  enum role: [:standard, :premium, :admin]
end
