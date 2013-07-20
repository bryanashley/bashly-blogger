class Commenter < ActiveRecord::Base
  has_many :comments

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |commenter|
      commenter.url = auth["info"]["urls"]["Twitter"]
      commenter.avatar = auth["info"]["image"]
      commenter.provider = auth["provider"]
      commenter.uid = auth["uid"]
      commenter.name = auth["info"]["nickname"]
    end
  end

end
