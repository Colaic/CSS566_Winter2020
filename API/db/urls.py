from django.urls import path

from . import views
from .views import *
# from .views import GetUserProfile
# from .views import GetCharacter
# from .views import GetMonster

urlpatterns = [
    path('', views.index, name='index'),
    path('user_create', CreateUserAPI.as_view(), name="createUser"),
    path('userInfo', GetUserProfile.as_view(), name="getUser"),

    path('character', GetCharacter.as_view(), name="getCharacter"),
    path('monster', GetMonster.as_view(), name="getMonster"),
    path('item', GetMonster.as_view(), name="getMonster")
]