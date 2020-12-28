import 'package:biller/page/add_customer_page.dart';
import 'package:biller/page/add_items_page.dart';
import 'package:biller/page/add_line_item_page.dart';
import 'package:biller/page/add_purchase_order_page.dart';
import 'package:biller/page/add_sale_order_page.dart';
import 'package:biller/page/customer_details_page.dart';
import 'package:biller/page/home_page.dart';
import 'package:biller/page/sale_order_details_page.dart';
import 'package:flutter/material.dart';

enum LineItemArgumentsType {
  saleOrder,
  purchaseOrder,
}

class LineItemArguments {
  final LineItemArgumentsType type;

  LineItemArguments({
    @required this.type,
  });
}

class DetailPageArgument {
  final int id;

  DetailPageArgument({
    @required this.id,
  });
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return _transit(HomePage());

      case AddCustomerPage.routeName:
        return _transit(AddCustomerPage());

      case AddItemsPage.routeName:
        return _transit(AddItemsPage());

      case AddPurchaseOrderPage.routeName:
        return _transit(AddPurchaseOrderPage());

      case AddSaleOrderPage.routeName:
        return _transit(AddSaleOrderPage());

      case AddLineItemPage.routeName:
        LineItemArguments args = settings.arguments;
        return _transit(AddLineItemPage(
          type: args.type,
        ));

      case SaleOrderDetailsPage.routeName:
        DetailPageArgument args = settings.arguments;
        return _transit(SaleOrderDetailsPage(
          id: args.id,
        ));

      case CustomerDetailsPage.routeName:
        DetailPageArgument args = settings.arguments;
        return _transit(CustomerDetailsPage(
          id: args.id,
        ));
      default:
        return _errorRoute();
    }
  }

  static PageRouteBuilder<dynamic> _transit(Widget returnPage) {
    return PageRouteBuilder(
      reverseTransitionDuration: Duration(milliseconds: 150),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return returnPage;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Container(
          child: Text("Error"),
        ),
      ),
    );
  }
}
