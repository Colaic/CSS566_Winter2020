from django.contrib import admin
from db.models import *

# Register your models here.
admin.site.register(CharacterLevel)
admin.site.register(Character)
admin.site.register(Monster)
admin.site.register(Mission)
admin.site.register(Item)
admin.site.register(UserItem)
admin.site.register(UserProfile)
