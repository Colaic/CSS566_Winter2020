from django.urls import path

from . import views
from .views import CreateUserAPI
from .views import GetUserProfile
from .views import GetCharacter
from .views import GetMonster

urlpatterns = [
    path('', views.index, name='index'),
    path('user_create', CreateUserAPI.as_view(), name="createUser"),
    path('get_userInfo', GetUserProfile.as_view(), name="getUser"),

    path('get_character', GetCharacter.as_view(), name="getCharacter"),
    path('get_monster', GetMonster.as_view(), name="getMonster")
]