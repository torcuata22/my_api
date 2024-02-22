class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true

  scope :recent, -> { order(created_at: :desc) } #define "recent" so I can use it in controller instead of .all
end
