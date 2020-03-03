docker-compose up


docker-compose run web python3 manage.py makemigrations

docker-compose run web python3 manage.py migrate

docker-compose run web python3 manage.py createsuperuser


docker-compose run web python3 manage.py test
