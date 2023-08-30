## Userモデル
- usersテーブル
  - name:string
  - email:string
  - password_digest:string

## Taskモデル
- tasksテーブル
  - title:string
  - content:text
  - expiry:date
  - priority:string
  - status:string

## Labelモデル
- labelsテーブル
  - user_id:string
  - task_id:string

## Gemのバージョン情報
[Gemfile](/Gemfile)と[Gemfile.lock](/Gemfile.lock)を参照

## デプロイ方法
- `git push heroku master`
- `heroku run rails db:migrate`