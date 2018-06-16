class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
          :rememberable, :trackable, :validatable,
          :omniauthable, omniauth_providers: [:evernote]

  has_many :songs, dependent: :destroy
  has_many :notebooks, dependent: :destroy

  def self.from_omniauth(auth)
    if (user = find_by_uid(auth.uid))
      user.provider = auth.provider
      user.evernote_token = auth.uid
      user.username = auth.info.name
      user.avatar = auth.info.image
      user.evernote_token = auth.credentials.token
      user.save
      user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = "#{auth.info.name}@exame.com"
        user.username = auth.info.name
        user.avatar = auth.info.image
        user.evernote_token = auth.credentials.token
        user.password = Devise.friendly_token[0,20] unless user.encrypted_password?
      end
    end
  end
end
