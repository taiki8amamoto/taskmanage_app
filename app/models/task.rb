class Task < ApplicationRecord
  belongs_to :user
  has_many :tags, dependent: :destroy
  has_many :labels, through: :tags, source: :label
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true, on: :update
  enum progress: { not_started: 0, in_progress: 5, done: 10 }
  enum priority: { low: 0, mid: 5, high: 10 }
  scope :search_by_title, -> (title){ where("title LIKE ?", "%#{title}%")}
  scope :search_by_progress, -> (progress){ where(progress: "#{progress}")}
end
