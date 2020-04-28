# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:evernote]

  has_many :songs, dependent: :destroy
  has_many :notebooks, dependent: :destroy

  def self.from_omniauth(auth)
    puts auth.inspect
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.update!(provider: auth.provider,
                  uid: auth.uid,
                  email: "#{auth.info.name}@example.com",
                  username: auth.info.name,
                  avatar: auth.info.image,
                  evernote_token: auth.credentials.token,
                  password: Devise.friendly_token[0, 20])
    end
  end
end
