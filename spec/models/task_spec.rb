require 'rails_helper'
RSpec.describe 'タスクモデル機能', type: :model do
  let!(:user1) { FactoryBot.create(:user) }
  let!(:task1) { FactoryBot.create(:task, user: user1) }
  let!(:task2) { FactoryBot.create(:second_task, user: user1) }
  let!(:task3) { FactoryBot.create(:third_task, user: user1) }

  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(title: '', content: '失敗テスト')
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(title: '失敗テスト', content: '')
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        user_id = Task.find_by(title: 'test title 1').user_id
        task = Task.new(title: '成功テスト', content: '成功テスト', user_id: user_id)
        expect(task).to be_valid
      end
    end
  end

  describe '検索ロジックのテスト' do
    context 'タイトルであいまい検索をした場合' do
      it '検索キーワードを含むタスクで絞り込まれる' do
        expect(Task.search_by_title('1')).to include(task1)
        expect(Task.search_by_title('1')).not_to include(task2)
        expect(Task.search_by_title('1').count).to eq 1
      end
    end
    context 'ステータス検索をした場合' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do
        expect(Task.search_by_progress('5')).to include(task1)
        expect(Task.search_by_progress('5')).not_to include(task2)
        expect(Task.search_by_progress('5').count).to eq 1
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it '検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる' do
        expect(Task.search_by_title_and_progress('title','5')).to include(task1)
        expect(Task.search_by_title_and_progress('title','5')).not_to include(task2)
        expect(Task.search_by_title_and_progress('title','5').count).to eq 1
      end
    end
  end

end