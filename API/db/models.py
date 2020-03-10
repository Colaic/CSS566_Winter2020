import uuid

from django.contrib.auth.models import User
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver


class CharacterLevel(models.Model):
    level = models.IntegerField(primary_key=True, editable=True)
    hp = models.IntegerField()
    mp = models.IntegerField()
    attack = models.IntegerField()
    defense = models.IntegerField()


class Character(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    level = models.OneToOneField(CharacterLevel, on_delete=models.PROTECT)
    name = models.CharField(max_length=30)
    specialAttack = models.IntegerField(default=0)


class Monster(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=30)
    hp = models.IntegerField()
    mp = models.IntegerField()
    attack = models.IntegerField()
    defense = models.IntegerField()
    level = models.IntegerField()


class Mission(models.Model):
    missionNum = models.IntegerField(primary_key=True, editable=True)
    cost = models.IntegerField()
    reward = models.IntegerField()
    monsters = models.ManyToManyField(Monster)


class Item(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    price = models.IntegerField()
    property = models.CharField(max_length=128)


class UserItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    item = models.OneToOneField(Item, on_delete=models.PROTECT)
    count = models.IntegerField()


class Player(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    currency = models.IntegerField(default=0)
    missionNum = models.OneToOneField(Mission, on_delete=models.PROTECT, blank=True, null=True)
    characters = models.ManyToManyField(Character)
    items = models.ManyToManyField(UserItem)
