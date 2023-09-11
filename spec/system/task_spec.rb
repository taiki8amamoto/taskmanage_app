require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user1) { FactoryBot.create(:user) }
  let!(:task1) { FactoryBot.create(:task, user: user1) }
  let!(:task2) { FactoryBot.create(:second_task, user: user1) }
  let!(:task3) { FactoryBot.create(:third_task, user: user1) }

  describe '新規作成機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
    end
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit tasks_path
        click_link '新規Task登録'
        fill_in 'task_title', with: 'テストだよ'
        fill_in 'task_content', with: 'テストですね'
        select '着手中', from: 'task_progress'
        select '高', from: 'task_priority'

        click_button '登録する'
        expect(page).to have_content 'テストだよ'
        expect(page).to have_content 'テストですね'
      end
    end
  end

  describe '一覧表示機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content 'test title 1'
        expect(page).to have_content 'test content 1'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('.task_row')
        expect(task_list[1]).to have_content 'test title 3'
      end
    end
    context 'タスクが終了期限の降順に並んでいる場合' do
      it '終了期限が若いタスクが最下行に表示される' do
        click_link '終了期限'
        sleep 0.5
        task_list = all('.task_row')
        expect(task_list[1]).to have_content 'test title 1'
      end
    end
    context 'タスクが終了期限の昇順に並んでいる場合' do
      it '終了期限が若いタスクが一番上に表示される' do
        click_link '終了期限'
        sleep 0.5
        click_link '終了期限'
        sleep 0.5
        task_list = all('.task_row')
        expect(task_list[1]).to have_content 'test title 3'
      end
    end
    context 'タスクが優先度の降順に並んでいる場合' do
      it '優先度が低いタスクが最下行に表示される' do
        click_link '優先度'
        sleep 0.5
        task_list = all('.task_row')
        expect(task_list[1]).to have_content 'test title 3'
      end
    end
    context 'タスクが優先度の昇順に並んでいる場合' do
      it '優先度が低いタスクが一番上に表示される' do
        click_link '優先度'
        sleep 0.5
        click_link '優先度'
        sleep 0.5
        task_list = all('.task_row')
        expect(task_list[1]).to have_content 'test title 2'
      end
    end
  end

  describe '詳細表示機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
    end
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit tasks_path
        task = Task.find_by(title: 'test title 2')
        expect(page).to have_link '詳細', href: task_path(task)
        click_link '詳細', href: task_path(task)
        expect(page).to have_content 'test title 2'
        expect(page).to have_content 'test content 2'
      end
    end
  end

  describe '検索機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      visit tasks_path
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        fill_in '検索...', with: '1'
        click_button '検索する'
        expect(page).to have_content 'test title 1'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        select '未着手', from: 'search_progress'
        click_button '検索する'
        expect(page).to have_content 'test title 2'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in '検索...', with: 'test title'
        select '完了', from: 'search_progress'
        click_button '検索する'
        expect(page).to have_content 'test title 3'
      end
    end
  end

end
