import 'package:biller/screens/customer_screen.dart';
import 'package:biller/screens/home_screen.dart';
import 'package:biller/screens/items_screen.dart';
import 'package:biller/screens/purchase_orders_screen.dart';
import 'package:biller/screens/sale_orders_screen.dart';
import 'package:biller/widget/nav_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 3;
  List<NavBarItem> drawerItems = [
    NavBarItem(
      icon: Icons.dashboard,
      title: 'Dashboard',
      page: HomeScreen(),
    ),
    NavBarItem(
      icon: Icons.all_inbox,
      title: 'Inventory',
      page: ItemsScreen(),
    ),
    NavBarItem(
      icon: Icons.assignment,
      title: 'Sale Order',
      page: SaleOrderScreen(),
    ),
    NavBarItem(
      icon: Icons.shopping_cart,
      title: 'Purchase Order',
      page: PurchaseOrderScreen(),
    ),
    NavBarItem(
      icon: Icons.people,
      title: 'Customers',
      page: CustomerScreen(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
        centerTitle: true,
      ),
      drawer: NavDrawer(
        listItems: drawerItems,
        onNavItemSelected: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        selected: _selectedPage,
      ),
      body: drawerItems[_selectedPage].page,
    );
  }

  String getTitle() {
    return drawerItems[_selectedPage].title;
  }
}
