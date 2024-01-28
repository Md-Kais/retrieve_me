import 'package:flutter/material.dart';
import 'drawer_item.dart';

final itemsFirst = [
  const DrawerItem(title: 'Post Lost Item', icon: Icons.phone_android_outlined),
  const DrawerItem(title: 'Post Found Item', icon: Icons.people),
  const DrawerItem(title: 'Lost Item List', icon: Icons.list),
  const DrawerItem(title: 'Found Item List', icon: Icons.list),
  const DrawerItem(title: 'Item Case History', icon: Icons.history),
];

final itemsSecond = [
  const DrawerItem(title: 'Chat', icon: Icons.chat),
  const DrawerItem(title: 'User Dashboard', icon: Icons.settings),
];

final itemsThird = [
  const DrawerItem(title: 'Logout', icon: Icons.logout),
];
