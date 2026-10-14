# Chess Ranking Web Site

## See
[Chess Ranking](https://chess-ranking.stu345.com/players)

## Prepare
- csv file for ranking. get from ncs web page

## Get Started
- `docker compose build`
- `docker compose run web rails db:create db:migrate db:seed`
- `docker compose up`
- `open http://localhost:3064/players`

### In Production
- copy config/master.key (this file is ignored from git)
    - or you can recreate credentials.yml.enc and master.key: 
        - `rm credentials.yml.enc`
        - `docker compose run -e EDITOR=vim web rails credentials:edit`
            - you need to set `Rails.application.credentials` variables
- `docker compose -f docker-compose.production.yml build`
- `docker compose -f docker-compose.production.yml up -d`
- reset database: `docker compose -f docker-compose.production.yml run web rails db:migrate:reset RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1`

### Update DB
- get a new excel file from NCS and export as csv file
- put the csv file to lib/assets
- `docker compose exec web rake 'data:import[rating-2026-01-05.csv]'`

- victory distance: `docker compose exec web rake victory_distance:save`

### 月別ラピッド順位の補完・再計算

`rapid_rank` は各年月の取り込み済みデータ内での順位です。会員・活動状態に関係なく、
ラピッドレーティングが正のレコードを降順に並べ、同点は同順位（1、2、2、4位）とします。
未レート（0）の順位はNULLです。外部公表順位とは異なります。
新規月のCSVインポートでは自動計算されます。

既存データはデプロイ時にマイグレーション後、全月を補完してください。
スキーマ変更だけでは既存レコードの順位はNULLのままです。

```bash
docker compose exec web rails db:migrate
docker compose exec web rake rapid_rank:recalculate
```

特定の月を再計算する場合（その月の全レコードが対象。日付は月初以外でも対象）：

```bash
docker compose exec web rake 'rapid_rank:recalculate[2026-01]'
```

各月を独立したトランザクションで処理し、年月と処理件数を出力します。
繰り返し実行可能で、レーティングを0に修正したレコードの古い順位もNULLに戻します。
本番環境では上記の `docker compose` を `docker compose -f docker-compose.production.yml` に置き換えてください。

## Development
- generate Home controller `docker compose run web rails g controller Users`

### after you change something
- `docker compose run web bundle install`
- `docker compose up --build`

### before Pull Request
- `docker compose exec web rubocop -A`
- `docker compose exec web rails test`

### sitemap
We use [sitemap_generator](https://github.com/kjvarga/sitemap_generator#rails).

Generate public/sitemap.xml.gz file by `rake sitemap:refresh`.

This file is ignored by git.

### pry
1. set `binding.pry`
1. check container id: `docker ps`
1. docker attach container_id
1. open browser
1. `exit`
1. Ctrl + q

### tasks
- `docker compose exec web rake add_rank:update_null_ranks`

## connect to the local DB
psql --host=localhost --port=5464 --username=postgres --password --dbname=chess_ranking_development
