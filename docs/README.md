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