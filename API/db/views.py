from django.db import IntegrityError
from django.http import HttpResponse
from rest_framework.generics import (CreateAPIView, GenericAPIView, ListAPIView)

from db.serializer import *


def index(request):
    return HttpResponse("API v0.3rc1")


class PermissionMixin(object):
    def is_manager(self):
        manager = User.objects.filter(username=self.request.user.username, is_superuser=True)
        if manager:
            return True
        return False


class GetPlayer(PermissionMixin, ListAPIView):
    serializer_class = PlayerListSerializer

    def get_queryset(self, *args, **kwargs):
        if self.is_manager():
            players = Player.objects
        else:
            players = Player.objects.filter(user=self.request.user)
        return players


class GetPlayerTest(PermissionMixin, ListAPIView):
    serializer_class = PlayerListSerializer

    def get_queryset(self, *args, **kwargs):
        return Player.objects


class CreateUserAPI(CreateAPIView):
    def post(self, request, *args, **kwargs):
        username = request.data['name']
        password = request.data['password']

        # raise Exception when username is too short
        if len(username) < 4:
            return HttpResponse(Exception("user name too short"), status=400)
        # raise Exception when password is too short
        if len(password) < 4:
            return HttpResponse(Exception("password too short"), status=400)
        user = User(username=username,
                    password=password)
        try:
            user.save()
            player = Player(user=user,
                            currency=0)
            player.save()
        except IntegrityError as e:
            return HttpResponse("Duplicated username", status=400)
        return HttpResponse("User Created", status=200)


class ChangePasswordAPI(GenericAPIView):
    def post(self, request, *args, **kwargs):
        username = request.data['name']
        oldPassword = request.data['oldPassword']
        newPassword = request.data['newPassword']
        # raise Exception when password is too short
        if len(newPassword) < 4:
            return HttpResponse(Exception("password too short"), status=400)

        # check if user exists or not
        try:
            user = Player.objects.get(user__username=username)
        except Player.DoesNotExist:
            return HttpResponse("User does not exists", status=400)

        # check the correctness of the old password
        if not user.user.check_password(oldPassword):
            return HttpResponse("Password is wrong", status=400)

        user.user.set_password(newPassword)
        user.user.save()
        return HttpResponse("Password changed", status=200)


class SignInAPI(GenericAPIView):
    def post(self, request, *args, **kwargs):
        username = request.data['name']
        password = request.data['password']

        # check if the username and password
        try:
            Player.objects.get(user__username=username, user__password=password)
        except Player.DoesNotExist:
            return HttpResponse("Wrong username or password", status=400)

        return HttpResponse("Signed in", status=200)
