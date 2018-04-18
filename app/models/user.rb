class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wikis, dependent: :destroy

  enum role: [:standard, :premium, :admin]

  after_initialize :init

  def init
     self.role ||= :standard
  end

  def going_public
    self.wikis.each { |wiki| puts wiki.publicize }
  end


end
