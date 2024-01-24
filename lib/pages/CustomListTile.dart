import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/UserModel.dart';

class CustomListTile extends StatelessWidget {
  final int serialNumber;
  final UserModel user;
  final VoidCallback? onTap;

  const CustomListTile({super.key,
    required this.serialNumber,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.black),
      ),
      child: ListTile(
        onTap: onTap, // Invoke the onTap callback when the ListTile is tapped
        title: Text("${user.firstName} ${user.lastName}"),
        subtitle: Text('Address: ${user.address}'),
        leading: CircleAvatar(
          child: Text(serialNumber.toString()),
        ),
        trailing: Text('✮ ${user.rating}'),
      ),
    );
  }
}
