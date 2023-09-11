2.times do |n|
  User.create!(name: "test0#{(n + 1).to_s}", email: "test0#{(n + 1).to_s}@example.com", password: "password", role: 0)
end

10.times do |n|
  User.create!(name: "test0#{(n + 3).to_s}", email: "test0#{(n + 3).to_s}@example.com", password: "password", role: 5)
end

titles = ["学習", "家事", "就活", "その他"]
study_contents = ["テキストを進める", "チェリー本を読む", "昨日の復習する", "明日の予習する", "技術記事を読む"]
housework_contents = ["掃除機かける", "エアコンフィルターの清掃", "買い物に行く", "風呂掃除する", "洗濯する"]
jobhunt_contents = ["Wantedlyで企業探しする", "面接練習する", "履歴書と職務経歴書をブラッシュアップする"]
other_contents = [ "自転車整備する", "ギターの調整する", "休む！"]
deadline_from = DateTime.parse('2023-01-01 00:00:00')
deadline_to   = DateTime.parse('2023-12-31 00:00:00')
progresses = [0, 5, 10]
created_at_from = Time.parse('2022-01-01 00:00:00')
created_at_to   = Time.parse('2022-12-31 00:00:00')
priorities = [0, 5, 10]
user_ids = (1..12).to_a

5000.times do
  title = titles.sample
  case title
  when "学習"
    content = study_contents.sample
  when "家事"
    content = housework_contents.sample
  when "就活"
    content = jobhunt_contents.sample
  when "その他"
    content = other_contents.sample
  end
  deadline = rand(deadline_from..deadline_to)
  progress = progresses.sample
  created_at = rand(created_at_from..created_at_to)
  priority = priorities.sample
  user_id = user_ids.sample
  Task.create!(title: title, content: content, deadline: deadline, progress: progress, created_at: created_at, priority: priority, user_id: user_id)
end
