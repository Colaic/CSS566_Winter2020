from django.test import TestCase
from django.urls import reverse

from .models import *


class UserProfileTest(TestCase):
    def setUp(self):
        hp_potion = Item.objects.create(id=uuid.uuid4(),
                                        name="hp potion",
                                        price="100",
                                        property="add hp")
        item = UserItem.objects.create(id=uuid.uuid4(),
                                       item=hp_potion,
                                       count=1)
        mission = Mission.objects.create(missionNum=0,
                                         cost=1,
                                         reward=10)
        user = User(username="tester",
                    password="pwd")
        user.save()
        player = Player.objects.create(user=user,
                                       currency="0",
                                       missionNum=mission)
        player.items.add(item)

    def test_user(self):
        tester = Player.objects.get(user__username="tester")
        self.assertEqual(tester.user.username, "tester")
        self.assertEqual(tester.user.password, "pwd")
        self.assertEqual(tester.currency, 0)
        self.assertEqual(tester.missionNum.missionNum, 0)
        self.assertEqual(tester.missionNum.cost, 1)
        self.assertEqual(tester.missionNum.reward, 10)
        self.assertEqual(tester.characters.count(), 0)
        self.assertEqual(tester.items.count(), 1)


class APITest(TestCase):
    def test_index(self):
        response = self.client.get(reverse('index'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "API v0.3rc1")
