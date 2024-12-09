# Chess Ranking Web Site

## See
[Chess Ranking](https://chess-ranking.stu345.com/players)

## Prepare
- csv file for ranking. get from ncs web page

## Get Started
- `docker compose build`
- `docker compose run web rails db:seed`
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
- `docker compose run web rails db:seed`

- victory distance: `docker compose exec web rake victory_distance:save`

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

## 公認クラブ
### 準備
- `docker compose exec web rake official_club:scrape` 公認クラブ一覧をjsonで保存する