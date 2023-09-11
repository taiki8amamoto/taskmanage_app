class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true, on: :update
  enum progress: { not_started: 0, in_progress: 5, done: 10 }
  enum priority: { low: 0, mid: 5, high: 10 }
  scope :search_by_title_and_progress, -> (title, progress){ where("title LIKE ?", "%#{(title)}%").where(progress: "#{(progress)}")}
  scope :search_by_title, -> (title){ where("title LIKE ?", "%#{title}%")}
  scope :search_by_progress, -> (progress){ where(progress: "#{progress}")}

end
