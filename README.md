# Chess Ranking Web Site

## See
[Chess Ranking](https://chess-ranking.stu345.com/players)

## Prepare
- csv file for ranking. get from ncs web page

## Run
- `docker-compose build`
- `docker-compose up`

### production
- copy config/master.key (this file is ignored from git)
    - or you can recreate credentials.yml.enc and master.key: 
        - `rm credentials.yml.enc`
        - `docker-compose run -e EDITOR=vim web rails credentials:edit`
- `docker-compose -f docker-compose.production.yml build`
- `docker-compose -f docker-compose.production.yml up -d`

## Development
- generate Home controller `docker-compose run web rails g controller Users`

### after you change something
- `docker-compose run web bundle install`
- `docker-compose up --build`
