
if you want to get the server up and running, you need to download a docker-compose.
afterwards, using the following command, you can get your docker up and running:
docker-compose up

The following command is used to making database changes. Everytime database schema is changed, you need to prepare for a migration, and then make the migration. You will need to run both command in order to make database updates:
docker-compose run web python3 manage.py makemigrations
docker-compose run web python3 manage.py migrate

Using the following command, you can create a super-user to login on the admin page of this project.
docker-compose run web python3 manage.py createsuperuser

Using the following command, you can run the test.py file and the process will be generated automatically:
docker-compose run web python3 manage.py test



