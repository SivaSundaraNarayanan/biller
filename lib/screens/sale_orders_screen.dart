import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/sale_order_service.dart';
import 'package:biller/page/add_sale_order_page.dart';
import 'package:biller/screens/empty_screen.dart';
import 'package:biller/util/constant_helper.dart';
import 'package:biller/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleOrderScreen extends StatefulWidget {
  @override
  _SaleOrderScreenState createState() => _SaleOrderScreenState();
}

class _SaleOrderScreenState extends State<SaleOrderScreen> {
  SaleOrderService _db;

  Future<List<SaleOrder>> _futureData;

  @override
  void initState() {
    super.initState();
    _db = SaleOrderService();

    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _futureData = _db.getSaleOrderWithItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder:
            (BuildContext context, AsyncSnapshot<List<SaleOrder>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasData && snapshot.data.length > 0) {
            List<SaleOrder> items = snapshot.data;
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                SaleOrder item = items[index];
                double price = 0;

                item.items.forEach((e) {
                  price += e.price * e.quantity;
                });
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(
                      '${item.orderNo}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Text(
                        '₹ $price',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(ConstantHelper.dateFormat)
                              .format(item.orderedOn),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            ...ConstantHelper.tracker
                                .map((e) => WidgetHelper.getSwitch(
                                      title: e,
                                      active: item.status >=
                                          ConstantHelper.tracker.indexOf(e),
                                    ))
                                .toList(),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
              itemCount: items.length,
            );
          }
          return EmptyScreen(title: 'Sale Order');
        },
        future: _futureData,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddSaleOrderPage.routeName)
              .then((value) {
            if (value != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sale Order created successfully'),
                ),
              );
              _fetchData();
            }
          });
        },
      ),
    );
  }
}
