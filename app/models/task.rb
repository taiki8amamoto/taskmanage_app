class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true, on: :update
  enum progress: { not_started: 0, in_progress: 5, done: 10 }
end
