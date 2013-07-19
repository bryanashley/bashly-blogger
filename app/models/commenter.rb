class Commenter < ActiveRecord::Base
  has_many :comments

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.url = auth["info"]["urls"]["Twitter"]
      user.avatar = auth["info"]["image"]
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

end
