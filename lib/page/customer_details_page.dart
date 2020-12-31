import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/customer_service.dart';
import 'package:biller/database/services/sale_order_service.dart';
import 'package:biller/page/sale_order_details_page.dart';
import 'package:biller/util/constant_helper.dart';
import 'package:biller/util/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsPage extends StatefulWidget {
  static const routeName = '/customer_detail';
  final int id;

  const CustomerDetailsPage({Key key, @required this.id}) : super(key: key);

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage>
    with TickerProviderStateMixin {
  final key = new GlobalKey<ScaffoldState>();

  CustomerService _customerService;
  SaleOrderService _saleOrderService;

  Customer _customer;
  List<SaleOrder> _orders = [];

  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);

    _customerService = CustomerService();
    _customerService.getCustomerById(this.widget.id).then((value) {
      setState(() {
        _customer = value;
      });
    });

    _saleOrderService = SaleOrderService();
    _saleOrderService.getSaleOrderByCustomerId(this.widget.id).then((value) {
      setState(() {
        _orders = value;
      });
    });

    super.initState();
  }

  void _handlePhoneCall() async {
    String _url = 'tel:${_customer.customerPhone}';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'cound not launch $_url';
    }
  }

  void _handleDelete(BuildContext context) {
    void _handleSuccess() {
      Navigator.of(context).pop();
      _customerService.deleteCustomer(_customer.id).then((count) {
        if (count == 1) {
          Navigator.of(context).pop(count);
        }
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "You cannot undo this action. Are you sure want to delete this contact"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
              textColor: Colors.grey,
            ),
            FlatButton(
              onPressed: _handleSuccess,
              child: Text('DELETE'),
              textColor: Colors.blue,
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 2,
        title: Text(_customer != null ? _customer.customerName : 'Loading...'),
        actions: [
          Tooltip(
            message: "Edit",
            child: IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {},
            ),
          ),
          Tooltip(
            message: "Delete",
            child: IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () => _handleDelete(context),
            ),
          ),
        ],
      ),
      body: _customer != null
          ? Column(
              children: [
                Container(
                  child: Material(
                    elevation: 2.0,
                    color: Colors.white,
                    child: TabBar(
                      tabs: [
                        Tab(
                          child: Text('Details'),
                        ),
                        Tab(
                          child: Text('Recent Orders'),
                        )
                      ],
                      unselectedLabelColor: Theme.of(context).primaryColor,
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).primaryColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _controller,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        detailsPage,
                        orderPage,
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget get orderPage => ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          double price = 0;
          SaleOrder order = _orders[index];

          order.items.forEach((e) {
            price += e.price * e.quantity;
          });

          return ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                SaleOrderDetailsPage.routeName,
                arguments: DetailPageArgument(
                  id: order.id,
                ),
              );
            },
            title: Text(
              order.orderNo,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              DateFormat(ConstantHelper.dateFormat).format(order.orderedOn),
            ),
            trailing: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[700],
                ),
              ),
              child: Text('$price'),
            ),
          );
        },
        itemCount: _orders.length,
      );

  Widget get detailsPage => Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Card(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 16),
                        Text(
                          _customer.customerName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onLongPress: () {
                            Clipboard.setData(
                              ClipboardData(text: _customer?.customerPhone),
                            );
                            key.currentState.showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: Text('Phone number copied!'),
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            child: Text(
                              _customer?.customerPhone,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 64,
                        width: 64,
                        child: InkWell(
                          onTap: _handlePhoneCall,
                          child: Icon(
                            Icons.phone,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  getTotalAmount(List<SaleOrderItem> items) {}
}
