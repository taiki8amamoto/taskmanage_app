class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true, on: :update
  enum progress: { not_started: 0, in_progress: 5, done: 10 }
  enum priority: { low: 0, mid: 5, high: 10 }
  scope :search_by_title_and_progress, -> (search_params){ where("title LIKE ?", "%#{(search_params[:title])}%").where(progress: "#{(search_params[:progress])}")}
  scope :search_by_title, -> (search_params){ where("title LIKE ?", "%#{search_params[:title]}%")}
  scope :search_by_progress, -> (search_params){ where(progress: "#{search_params[:progress]}")}

end
