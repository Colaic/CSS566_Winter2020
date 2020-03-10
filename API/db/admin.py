from django.contrib import admin
from db.models import *


class CharacterLevelAdmin(admin.ModelAdmin):
    list_display = ['level']


class CharacterAdmin(admin.ModelAdmin):
    list_display = ['name']


class ItemAdmin(admin.ModelAdmin):
    list_display = ['name', 'price']


class MissionAdmin(admin.ModelAdmin):
    list_display = ['missionNum', 'cost', 'reward']


class PlayerAdmin(admin.ModelAdmin):
    list_display = ['user_username', 'currency', 'missionNum']

    def user_username(self, user):
        return user.user.username
    user_username.short_description = 'Player username'


admin.site.register(CharacterLevel, CharacterLevelAdmin)
admin.site.register(Character, CharacterAdmin)
admin.site.register(Item, ItemAdmin)
admin.site.register(Mission, MissionAdmin)
admin.site.register(Monster)
admin.site.register(Player, PlayerAdmin)
admin.site.register(UserItem)
