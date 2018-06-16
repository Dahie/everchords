class Notebook < ApplicationRecord
  belongs_to :user
  has_many :songs, dependent: :destroy
end
