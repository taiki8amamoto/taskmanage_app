progresses = [0, 5, 10]
deadlines = [0, 5, 10]

datetime_from = DateTime.parse('2023-01-01 00:00:00')
datetime_to   = DateTime.parse('2023-12-31 00:00:00')

time_from = Time.parse('2022-01-01 00:00:00')
time_to   = Time.parse('2022-12-31 00:00:00')

1000.times do |n|
  title = Faker::JapaneseMedia::StudioGhibli.character
  content = Faker::JapaneseMedia::StudioGhibli.character
  deadline = rand(datetime_from..datetime_to)
  progress = progresses.sample
  created_at = rand(time_from..time_to)
  Task.create!(title: title, content: content, deadline: deadline, progress: progress, created_at: created_at)
end
