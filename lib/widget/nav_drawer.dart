import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final int selected;
  final Function(int) onNavItemSelected;
  final List<NavBarItem> listItems;

  const NavDrawer({
    Key key,
    this.selected = 0,
    @required this.onNavItemSelected,
    this.listItems = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 2*AppBar().preferredSize.height ,
            child: DrawerHeader(
              child: Center(
                child: Text(
                  'App',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: .75,
                    fontSize: 16
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
          ),
          ...getNavBarItems(context),
        ],
      ),
    );
  }

  List<ListTile> getNavBarItems(BuildContext context) {
    List<ListTile> _items = List<ListTile>();
    for (var index = 0; index < listItems.length; index++) {
      _items.add(
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
            onNavItemSelected(index);
          },
          selectedTileColor: Colors.grey[300],
          title: Text(listItems[index].title),
          leading: Icon(listItems[index].icon),
          selected: selected == index,
        ),
      );
    }
    return _items;
  }
}

class NavBarItem {
  final String title;
  final IconData icon;
  final Widget page;

  NavBarItem({this.title, this.icon, this.page});
}
