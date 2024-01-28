import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/drawer_item.dart';
import 'package:retrieve_me/Components/drawer_items.dart';
import 'package:retrieve_me/auth/auth_services.dart';
import 'package:retrieve_me/pages/foundItemList.dart';
import 'package:retrieve_me/pages/lostItemList.dart';
import 'package:retrieve_me/pages/postFoundItem.dart';
import 'package:retrieve_me/pages/postLostItem.dart';
import 'package:retrieve_me/pages/profilePage.dart';

import '../pages/login.dart';
import '../provider/navigation_provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationProvider>(context);
    const safeArea = EdgeInsets.symmetric(horizontal: 15, vertical: 20);
    final isCollapsed = provider.isCollapsed;

    return SizedBox(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.15 : null,
      child: Drawer(
        child: Container(
            color: const Color(0xFF1a2f45),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15).add(safeArea),
                  width: double.infinity,
                  color: const Color.fromARGB(255, 9, 0, 56),
                  child: buildHeader(isCollapsed),
                ),
                const SizedBox(height: 24),
                Container(
                  // padding: padding,
                  child: buildListItems(
                      items: itemsFirst, isCollapsed: isCollapsed),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white70),
                const SizedBox(height: 12),
                Container(
                  // padding: padding,
                  child: buildListItems(
                      items: itemsSecond, isCollapsed: isCollapsed),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white70),
                const SizedBox(height: 12),
                Container(
                  // padding: padding,
                  child: buildListItems(
                      items: itemsThird, isCollapsed: isCollapsed),
                ),
                const Spacer(),
                buildCollapseIcon(context, isCollapsed),
                const SizedBox(height: 16),
              ],
            )),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? const FlutterLogo(size: 48)
      : Row(
          children: [
            const SizedBox(width: 24),
            const FlutterLogo(size: 48),
            const SizedBox(width: 20),
            Text('Retrieve-Me',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color.fromARGB(255, 5, 121, 179),
                  ),
                )),
          ],
        );

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    const double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : const EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;
    return Container(
        alignment: alignment,
        margin: margin,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: SizedBox(
                width: width,
                height: size,
                child: Icon(icon, color: Colors.white),
              ),
              onTap: () {
                final provider =
                    Provider.of<NavigationProvider>(context, listen: false);
                provider.toggleCollapsed();
              },
            )));
  }

  buildListItems(
          {required List<DrawerItem> items, required bool isCollapsed}) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, index, item.title),
          );
        },
      );

  buildMenuItem(
      {required bool isCollapsed,
      required String text,
      required IconData icon,
      VoidCallback? onClicked}) {
    const color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
        color: Colors.transparent,
        child: isCollapsed
            ? ListTile(
                leading: leading,
                onTap: onClicked,
              )
            : ListTile(
                leading: leading,
                title: Text(text,
                    style: const TextStyle(color: color, fontSize: 16)),
                onTap: onClicked,
              ));
  }

  selectItem(BuildContext context, int index, String itemTitle) async {
    navigateTo(page) => Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => page,
        ));
    switch (itemTitle) {
      case 'Post Lost Item':
        navigateTo(const PostLostItemPage());
        break;
      case 'Post Found Item':
        navigateTo(const PostFoundItemPage());
        break;
      case 'Lost Item List':
        navigateTo(const LostItemListPage());
        break;
      case 'Found Item List':
        navigateTo(const FoundItemListPage());
        break;
      case 'User Dashboard':
        navigateTo(ProfilePage());
        break;
      case 'Logout':
        // logout and navigate to LoginPage()
        await AuthService.logout();
        navigateTo(LoginPage());
        break;
    }
    // switch (index) {
    //   case 0:
    //     selectItem(BuildContext context, int index) {
    //       final navigateTo =
    //           (page) => Navigator.of(context).push(MaterialPageRoute(
    //                 builder: (context) => page,
    //               ));

    //       if (Navigator.of(context).canPop()) {
    //         Navigator.of(context).pop();
    //       }

    //       switch (index) {
    //         case 0:
    //           if (ModalRoute.of(context)?.settings.name != '/postLostItem') {
    //             navigateTo(PostLostItemPage());
    //           }
    //           break;
    //         case 1:
    //           if (ModalRoute.of(context)?.settings.name != '/postFoundItem') {
    //             navigateTo(PostFoundItemPage());
    //           }
    //           break;
    //       }
    //     }
    // }
  }
}
