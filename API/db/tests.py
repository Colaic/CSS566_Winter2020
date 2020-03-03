from django.test import TestCase
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
        user = UserProfile.objects.create(id=uuid.uuid4(),
                                          username="tester",
                                          password="pwd",
                                          currency="0",
                                          missionNum=mission)
        user.items.add(item)

    def test_user(self):
        tester = UserProfile.objects.get(username="tester")
        self.assertEqual(tester.username, "tester")
        self.assertEqual(tester.password, "pwd")
        self.assertEqual(tester.currency, 0)
        self.assertEqual(tester.missionNum.missionNum, 0)
        self.assertEqual(tester.missionNum.cost, 1)
        self.assertEqual(tester.missionNum.reward, 10)
        self.assertEqual(tester.characters.count(), 0)
        self.assertEqual(tester.items.count(), 1)
