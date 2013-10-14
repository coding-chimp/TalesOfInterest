class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :recoverable
  # :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def after_database_authentication
    if Rails.env.production?
      tracker = Mixpanel::Tracker.new("a3a2ed0c35530c080cce37422adca289")
      tracker.track(self.id, 'Logged In')
    end
  end

end
