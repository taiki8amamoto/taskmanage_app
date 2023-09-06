FactoryBot.define do
  factory :task do
    title { 'test title 1' }
    content { 'test content 1' }
    deadline { '2023-08-01' }
    progress { 5 }
  end
  factory :second_task, class: Task do
    title { 'test title 2' }
    content { 'test content 2' }
    deadline { '2022-05-01' }
    progress { 0 }
  end
  factory :third_task, class: Task do
    title { 'test title 3' }
    content { 'test content 3' }
    deadline { '2021-01-01' }
    progress { 10 }
  end
end