# == Schema Information
#
# Table name: songs
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  guid       :string
#

class Song < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :title, presence: true
  validates :body, presence: true

  def update_from_evernote(evernote_note)
    self.body = evernote_note.content
    self.title = evernote_note.title
  end
end
