import json
import uuid
from django.http import HttpResponse
from django.shortcuts import render
from rest_framework.generics import (CreateAPIView, GenericAPIView, ListAPIView, RetrieveAPIView, UpdateAPIView)
from db.models import *


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
    #
    # def get(self, request, school_id, *args, **kwargs):
    #     self.school_id = school_id
    #     return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        # try:

        user = UserProfile(username=request.data['name']
                           , password=request.data['password']
                           , currency=0
                           )
        user.save()
        # except Exception as e:
        #     return HttpResponse(e, status=500)

        return HttpResponse("User Created", status=200)
