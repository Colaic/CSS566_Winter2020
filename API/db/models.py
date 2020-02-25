from django.db import models
import uuid


class CharacterLevel(models.Model):
    level = models.IntegerField(primary_key=True, editable=False)
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
    missionNum = models.IntegerField(primary_key=True, editable=False)
    cost = models.IntegerField()
    reward = models.IntegerField()
    monsters = models.ManyToManyField(Monster)


class Item(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50)
    price = models.IntegerField()
    property = models.CharField(max_length=128)


class Backpack(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    item = models.OneToOneField(Item, on_delete=models.PROTECT)
    count = models.IntegerField()


class UserProfile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=128)
    currency = models.IntegerField()
    missionNum = models.OneToOneField(Mission, on_delete=models.PROTECT, blank=True, null=True)
    characters = models.ManyToManyField(Character, blank=True, null=True)
    backpack = models.OneToOneField(Backpack, on_delete=models.PROTECT, blank=True,null=True)
