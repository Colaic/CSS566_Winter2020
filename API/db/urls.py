from django.urls import path

from . import views
from .views import *

urlpatterns = [
    path('', views.index, name='index'),
    path('user_create', CreateUserAPI.as_view(), name="createUser"),
    path('change_password', ChangePasswordAPI.as_view(), name="changePassword"),
    path('sign_in', SignInAPI.as_view(), name="signIn"),

    # APIs requiring token
    path('player', GetPlayer.as_view(), name="getPlayer"),
    path('player-deprecated', GetPlayerTest.as_view(), name="getPlayer_deprecated"),
]
