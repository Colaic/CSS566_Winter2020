
if you want to get the server up and running, you need to download a docker-compose.
afterwards, using the following command, you can get your docker up and running:

code: docker-compose up

The following command is used to making database changes. Everytime database schema is changed, you need to prepare for a migration, and then make the migration. You will need to run both command in order to make database updates:

code: docker-compose run web python3 manage.py makemigrations
code: docker-compose run web python3 manage.py migrate

Using the following command, you can create a super-user to login on the admin page of this project.

code: docker-compose run web python3 manage.py createsuperuser

Using the following command, you can run the test.py file and the process will be generated automatically:

code: docker-compose run web python3 manage.py test

In the db_config.env file, the last line is intentionally left as SECRET_KEY=fake. Please change the "fake" to be a 64-bit string of characters to make it work. Since it is local, you can change it to anything you want to, as long as it is a 64 bit string.



