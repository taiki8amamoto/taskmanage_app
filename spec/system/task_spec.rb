require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
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
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        FactoryBot.create(:task)
        visit tasks_path
        expect(page).to have_content 'Factoryで作ったデフォルトのタイトル１'
        expect(page).to have_content 'Factoryで作ったデフォルトのコンテント１'
      end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
        FactoryBot.create(:second_task)
        visit tasks_path
        task = Task.find_by(title: 'Factoryで作ったデフォルトのタイトル２')
        expect(page).to have_link '詳細を確認する', href: task_path(task)
        click_link '詳細を確認する', href: task_path(task)
        expect(page).to have_content 'Factoryで作ったデフォルトのタイトル２'
        expect(page).to have_content 'Factoryで作ったデフォルトのコンテント２'
       end
     end
  end
end
