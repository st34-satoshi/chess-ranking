# Chess Ranking Web Site

## See
[Chess Ranking](https://chess-ranking.stu345.com/players)

## Prepare
- csv file for ranking. get from ncs web page

## Run
- `docker-compose build`
- `docker-compose run web yarn install`
- `docker-compose run web rails db:seed`
- `docker-compose up`
- `open http://localhost:3064/players`

### production
- copy config/master.key (this file is ignored from git)
    - or you can recreate credentials.yml.enc and master.key: 
        - `rm credentials.yml.enc`
        - `docker-compose run -e EDITOR=vim web rails credentials:edit`
            - you need to set `Rails.application.credentials` variables
- `docker-compose -f docker-compose.production.yml build`
- `docker-compose -f docker-compose.production.yml run web yarn install --production`
- `docker-compose -f docker-compose.production.yml run web rails db:migrate:reset RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1`
- `docker-compose -f docker-compose.production.yml up -d`

## Development
- generate Home controller `docker-compose run web rails g controller Users`

### after you change something
- `docker-compose run web bundle install`
- `docker-compose up --build`

### before Pull Request
- `docker-compose run web rubocop -A`
- `docker-compose run web yarn run lint:js`
- `docker-compose run web yarn run lint:stylesheet`
- `docker-compose run web rails test`

### sitemap
We use [sitemap_generator](https://github.com/kjvarga/sitemap_generator#rails).

Generate public/sitemap.xml.gz file by `rake sitemap:refresh`.

This file is ignored by git.
