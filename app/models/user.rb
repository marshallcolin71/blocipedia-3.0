class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wikis, dependent: :destroy

  enum role: [:standard, :premium, :admin]

  after_initialize :init

  def init
     self.role ||= :standard
  end
  
end
