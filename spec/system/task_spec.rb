require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:task1) { FactoryBot.create(:task) }
  let!(:task2) { FactoryBot.create(:second_task) }
  let!(:task3) { FactoryBot.create(:third_task) }
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit tasks_path
        click_link '新しくTaskを投稿する'
        fill_in 'task_title', with: 'テストだよ'
        fill_in 'task_content', with: 'テストですね'
        click_button '登録する'
        expect(page).to have_content 'テストだよ'
        expect(page).to have_content 'テストですね'
      end
    end
  end
  describe '一覧表示機能' do
    before {visit tasks_path}
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content 'test title 1'
        expect(page).to have_content 'test content 1'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'test title 3'
      end
    end
    context 'タスクが終了期限の降順に並んでいる場合' do
      it '終了期限が若いタスクが最下行に表示される' do
        click_link '終了期限'
        sleep 0.5
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'test title 1'
      end
    end
    context 'タスクが終了期限の昇順に並んでいる場合' do
      it '終了期限が若いタスクが一番上に表示される' do
        click_link '終了期限'
        sleep 0.5
        click_link '終了期限'
        sleep 0.5
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'test title 3'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit tasks_path
        task = Task.find_by(title: 'test title 2')
        expect(page).to have_link '詳細を確認する', href: task_path(task)
        click_link '詳細を確認する', href: task_path(task)
        expect(page).to have_content 'test title 2'
        expect(page).to have_content 'test content 2'
      end
    end
  end
end
