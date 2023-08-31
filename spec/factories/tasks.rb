FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    title { 'test title 1' }
    content { 'test content 1' }
    deadline { '2023-08-01' }
  end
  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    title { 'test title 2' }
    content { 'test content 2' }
    deadline { '2022-05-01' }
  end
  factory :third_task, class: Task do
    title { 'test title 3' }
    content { 'test content 3' }
    deadline { '2021-01-01' }
  end
end