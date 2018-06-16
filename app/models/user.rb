# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  uid                    :string
#  evernote_token         :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  username               :string
#  avatar                 :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
          :rememberable, :trackable, :validatable,
          :omniauthable, omniauth_providers: [:evernote]

  has_many :songs
  has_many :notebooks

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
