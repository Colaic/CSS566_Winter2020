import json
import uuid
from django.http import HttpResponse
from django.shortcuts import render
from rest_framework.generics import (CreateAPIView, GenericAPIView, ListAPIView, RetrieveAPIView, UpdateAPIView)
from db.models import *
from django.db import IntegrityError


def index(request):
    return HttpResponse("Hello, world.")


class GetMonster(GenericAPIView):
    def get(self, request, *args, **kwargs):
        return HttpResponse(Monster.objects.filter(name=request.query_params['monsterName']))


class GetItem(GenericAPIView):
    def get(self, request, *args, **kwargs):
        return HttpResponse(Item.objects.filter(id=request.query_params['itemId']))


class GetCharacter(GenericAPIView):

    def get(self, request, *args, **kwargs):
        return HttpResponse(Character.objects.filter(id=request.query_params['characterId']))


class GetUserProfile(GenericAPIView):

    def get(self, request, *args, **kwargs):
        return HttpResponse(UserProfile.objects.filter(id=request.query_params['userId']))


class CreateUserAPI(GenericAPIView):
    # def get_queryset(self, *args, **kwargs):
    #     courses = Course.objects.filter(category=self.school_id)
    #     if not self.is_manager():
    #         courses = courses.filter(university_school=self.request.user)
    #     return courses

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
                           , currency=0
                           )
        try:
            user.save()
        except IntegrityError as e:
            return HttpResponse("Duplicated username", status=400)
        # except Exception as e:
        #     return HttpResponse(e, status=500)

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
