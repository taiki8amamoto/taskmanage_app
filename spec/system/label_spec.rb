require 'rails_helper'
RSpec.describe 'ラベル機能', type: :system do
  let!(:user1) { FactoryBot.create(:user) }
  let!(:task1) { FactoryBot.create(:task, user: user1) }
  let!(:task2) { FactoryBot.create(:second_task, user: user1) }
  let!(:task3) { FactoryBot.create(:third_task, user: user1) }
  let!(:label1) { FactoryBot.create(:label) }
  let!(:label2) { FactoryBot.create(:second_label) }
  let!(:label3) { FactoryBot.create(:third_label) }

  describe 'ラベル登録機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
    end
    context 'タスクを新規作成した場合' do
      it 'ラベルを一緒に登録できる' do
        visit tasks_path
        click_link '新規Task登録'
        fill_in 'task_title', with: 'テストだよ'
        fill_in 'task_content', with: 'テストですね'
        select '着手中', from: 'task_progress'
        select '高', from: 'task_priority'
        check 'label1'
        click_button '登録する'
        expect(page).to have_content 'テストだよ'
        expect(page).to have_content 'テストですね'
      end
    end
  end

  describe 'ラベル表示機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      visit tasks_path
      click_link '新規Task登録'
      fill_in 'task_title', with: 'テストだよ'
      fill_in 'task_content', with: 'テストですね'
      select '着手中', from: 'task_progress'
      select '高', from: 'task_priority'
      check 'label1'
      click_button '登録する'
    end
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクに紐づくラベルが全て表示される' do
        visit tasks_path
        task = Task.find_by(title: 'テストだよ')
        expect(page).to have_link '詳細', href: task_path(task)
        click_link '詳細', href: task_path(task)
        expect(page).to have_content 'label1'
      end
    end
  end

  describe 'ラベル検索機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
    end
    context 'ラベル検索をした場合' do
      it "ラベルに完全一致するタスクが絞り込まれる" do
        visit tasks_path
        click_link '新規Task登録'
        fill_in 'task_title', with: 'テストだよ'
        fill_in 'task_content', with: 'テストですね'
        select '着手中', from: 'task_progress'
        select '高', from: 'task_priority'
        check 'label2'
        click_button '登録する'
        select "label2", from: "search_label"
        click_button '検索する'
        expect(page).to have_content 'label2'
      end
    end
  end

end
