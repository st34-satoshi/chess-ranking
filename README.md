# Chess Ranking Web Site

## Demo
[Chess Ranking](https://chess-ranking.stu345.com/players)

## Run
- `docker-compose build`
- `docker-compose up`

### after you change something
-  `docker-compose run web bundle install`
- `docker-compose up --build`

### production
- copy config/master.key (this file is ignored from git)
    - or you can recreate credentials.yml.enc and master.key: 
        - `rm credentials.yml.enc`
        - `docker-compose run -e EDITOR=vim web rails credentials:edit`
- `docker-compose -f docker-compose.production.yml build`
- `docker-compose -f docker-compose.production.yml up -d`

## Development
- generate Home controller `docker-compose run web rails g controller Users`



## Reference
- [Quickstart: Compose and Rails | Docker Documentation](https://docs.docker.com/samples/rails/)