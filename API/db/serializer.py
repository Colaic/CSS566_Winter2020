from rest_framework.serializers import ModelSerializer, SerializerMethodField

from db.models import *


class PlayerSerializer(ModelSerializer):
    username = SerializerMethodField()
    missionNum = SerializerMethodField()
    characters = SerializerMethodField()
    userItem = SerializerMethodField()

    class Meta:
        model = Player
        fields = ('username', 'currency', 'missionNum', 'characters', 'userItem')

    def get_username(self, obj):
        return obj.user.username

    def get_missionNum(self, obj):
        if obj.missionNum is None:
            return "None"
        return obj.missionNum.missionNum

    def get_characters(self, obj):
        return CharacterSerializer(obj.characters, many=True).data

    def get_userItem(self, obj):
        return UserItemSerializer(obj.items, many=True).data


class CharacterSerializer(ModelSerializer):

    class Meta:
        model = Character
        fields = ('id', 'name',)


class UserItemSerializer(ModelSerializer):
    item = SerializerMethodField()

    class Meta:
        model = UserItem
        fields = ('item', 'count')

    def get_item(self, obj):
        return ItemSerializer(obj.item).data


class ItemSerializer(ModelSerializer):

    class Meta:
        model = Item
        fields = ('id', 'name')
