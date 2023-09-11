require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user1) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:second_user) }
  let!(:user3) { FactoryBot.create(:third_user) }

  describe 'ユーザ登録のテスト' do
    before {visit new_user_path}
    context 'ユーザーが新規登録した場合' do
      it '新規登録が成功すること' do
        fill_in '名前', with: 'test01'
        fill_in 'メールアドレス', with: 'test01@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_button '登録する'
        expect(page).to have_content 'test01'
        expect(page).to have_content 'test01@example.com'
        expect(page).to have_content 'test01でログイン中'
      end
    end
    context 'ユーザがログインせずタスク一覧画面に飛ぼうとした場合' do
      it 'ログイン画面に遷移すること' do
        click_on 'ロゴ'
        sleep 0.5
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'セッション機能のテスト' do
    before {visit new_session_path}
    it 'ログインができること' do
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content 'name1'
      expect(page).to have_content 'name1@example.com'
      expect(page).to have_content 'name1でログイン中'
    end
    it '自分の詳細画面(マイページ)に飛べること' do
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      click_link 'Myページ'
      expect(page).to have_content 'name1'
      expect(page).to have_content 'name1@example.com'
    end
    it '一般ユーザが他人の詳細画面に飛ぶとタスク一覧画面に遷移すること' do
      fill_in 'session_email', with: 'name2@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      visit user_path(1)
      expect(page).to have_content '他のユーザー詳細を確認するためには管理者権限が必要です'
    end
    it 'ログアウトができること' do
      fill_in 'session_email', with: 'name1@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      click_link 'ログアウト'
      expect(page.accept_confirm).to eq "ログアウトしますか？"
      expect(page).to have_content "ログアウトしました"
      expect(current_path).to eq new_session_path
    end
  end

  describe '管理画面のテスト' do
    context '管理者の場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'name1@example.com'
        fill_in 'session_password', with: 'password'
        click_button 'ログイン'
      end
      it '管理画面にアクセスできること' do
        click_link 'ユーザー一覧'
        expect(current_path).to eq admin_users_path
      end
      it 'ユーザの新規登録ができること' do
        click_link '新規ユーザー登録'
        expect(current_path).to eq new_admin_user_path
        fill_in '名前', with: 'name4'
        fill_in 'メールアドレス', with: 'name4@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        select '管理者', from: 'ユーザー種別'
        click_button '登録する'
        expect(page).to have_content "name3"
        expect(page).to have_content "name3@example.com"
      end
      it 'ユーザの詳細画面にアクセスできること' do
        click_link 'ユーザー一覧'
        user = User.find_by(name: 'name2')
        click_link '詳細', href: admin_user_path(user)
        expect(page).to have_content 'name2のページ'
      end
      it 'ユーザの編集画面からユーザを編集できること' do
        click_link 'ユーザー一覧'
        user = User.find_by(name: 'name2')
        click_link '編集', href: edit_admin_user_path(user)
        expect(page.accept_confirm).to eq "このユーザーを編集しますか？"
        fill_in '名前', with: 'name4'
        fill_in 'メールアドレス', with: 'name4@example.com'
        fill_in 'user_password', with: 'password4'
        fill_in 'user_password_confirmation', with: 'password4'
        select '管理者', from: 'ユーザー種別'
        click_button '更新する'
        expect(page).to have_content 'name4'
        expect(page).to have_content 'name4@example.com'
      end
      it 'ユーザの削除ができること' do
        click_link 'ユーザー一覧'
        user = User.find_by(name: 'name2')
        click_link '削除', href: admin_user_path(user)
        expect(page.accept_confirm).to eq "このユーザーを削除しますか？"
        expect(page).to have_content "name2のアカウントを削除しました！"
      end
    end
    context '一般ユーザーの場合' do
      it '管理画面にアクセスできないこと' do
        visit new_session_path
        fill_in 'session_email', with: 'name2@example.com'
        fill_in 'session_password', with: 'password'
        click_button 'ログイン'
        visit admin_users_path
        expect(page).to have_content "ユーザー一覧を確認するためには管理者権限が必要です"
        expect(current_path).to eq tasks_path
      end
    end
  end
end
