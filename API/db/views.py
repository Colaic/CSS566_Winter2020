from django.db import IntegrityError
from django.http import HttpResponse
from rest_framework.generics import (CreateAPIView, GenericAPIView, ListAPIView)

from db.models import *


def index(request):
    return HttpResponse("API v0.2.2")


class GetMonster(ListAPIView):
    def get(self, request, *args, **kwargs):
        return HttpResponse(Monster.objects.filter(name=request.query_params['monsterName']))


class GetItem(ListAPIView):
    def get(self, request, *args, **kwargs):
        return HttpResponse(Item.objects.filter(id=request.query_params['itemId']))


class GetCharacter(ListAPIView):
    def get(self, request, *args, **kwargs):
        return HttpResponse(Character.objects.filter(id=request.query_params['characterId']))


class GetUserProfile(ListAPIView):
    def get(self, request, *args, **kwargs):
        return HttpResponse(UserProfile.objects.filter(id=request.query_params['userId']))


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
        user = UserProfile(username=username
                           , password=password
                           , currency=0)
        try:
            user.save()
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
            user = UserProfile.objects.get(username=username)
        except UserProfile.DoesNotExist:
            return HttpResponse("User does not exists", status=400)

        # check the correctness of the old password
        if user.password != oldPassword:
            return HttpResponse("Password is wrong", status=400)

        user.password = newPassword
        user.save()
        return HttpResponse("Password changed", status=200)


class SignInAPI(GenericAPIView):
    def post(self, request, *args, **kwargs):
        username = request.data['name']
        password = request.data['password']

        # check if the username and password
        try:
            UserProfile.objects.get(username=username, password=password)
        except UserProfile.DoesNotExist:
            return HttpResponse("Wrong username or password", status=400)

        return HttpResponse("Signed in", status=200)
