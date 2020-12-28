import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/sale_order_service.dart';
import 'package:biller/page/customer_details_page.dart';
import 'package:biller/util/constant_helper.dart';
import 'package:biller/util/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleOrderDetailsPage extends StatefulWidget {
  static const routeName = '/sale_order_detail';
  final int id;

  const SaleOrderDetailsPage({Key key, @required this.id}) : super(key: key);

  @override
  _SaleOrderDetailsPageState createState() => _SaleOrderDetailsPageState();
}

class _SaleOrderDetailsPageState extends State<SaleOrderDetailsPage> {
  SaleOrderService _saleOrderService;
  SaleOrder _saleOrder;

  @override
  void initState() {
    super.initState();
    _saleOrderService = SaleOrderService();
    _saleOrderService.getSaleOrderById(this.widget.id).then((value) {
      setState(() {
        _saleOrder = value;
      });
    });
  }

  void _handleEdit() {}

  void _handleDelete() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: Text('Sale Order'),
        actions: [
          Tooltip(
            message: 'Edit',
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: _handleEdit,
            ),
          ),
          Tooltip(
            message: 'Print',
            child: IconButton(
              icon: Icon(Icons.print),
              onPressed: _handleDelete,
            ),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => ['Delete']
                .map(
                  (e) => PopupMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            onSelected: (item) {
              print(item);
            },
          ),
        ],
      ),
      body: _saleOrder != null
          ? Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _saleOrder.orderNo,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              CustomerDetailsPage.routeName,
                              arguments: DetailPageArgument(
                                id: _saleOrder.customer.id,
                              ),
                            );
                          },
                          child: Text(
                            _saleOrder.customer.customerName,
                            style: TextStyle(
                              color: Colors.grey[100],
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          getTotal(_saleOrder),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Order date:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[100],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              DateFormat(ConstantHelper.dateFormat)
                                  .format(_saleOrder.orderedOn),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Card(
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ),
                                children: [
                                  ...['Items', 'Amount']
                                      .map(
                                        (e) => Container(
                                          alignment: e == 'Amount'
                                              ? Alignment.bottomRight
                                              : Alignment.bottomLeft,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 20),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                              ..._saleOrder.items
                                  .map(
                                    (e) => TableRow(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.item.itemName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                '${e.quantity} * ${ConstantHelper.rupeeSymbol}${e.price}',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            '${ConstantHelper.rupeeSymbol}${e.price * e.quantity}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList()
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  getTotal(_saleOrder),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

String getTotal(SaleOrder saleOrder) {
  double total = 0;
  saleOrder.items.forEach((element) {
    total += element.price * element.quantity;
  });
  return '${ConstantHelper.rupeeSymbol}$total';
}
