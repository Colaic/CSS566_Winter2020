from django.urls import path

from . import views
from .views import *

urlpatterns = [
    path('', views.index, name='index'),
    path('sign_in', SignInAPI.as_view(), name="signIn"),

    # APIs requiring token
    path('player/create', CreateUserAPI.as_view(), name="createPlayer"),
    path('player', GetPlayer.as_view(), name="getPlayer"),
    path('player-deprecated', GetPlayerTest.as_view(), name="getPlayer_deprecated"),
    path('player/<user__username>/change', ChangePlayer.as_view(), name="changePlayer"),
    path('player/change_password', ChangePasswordAPI.as_view(), name="changePassword"),
]
