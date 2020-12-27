import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/customer_service.dart';
import 'package:biller/database/services/sale_order_service.dart';
import 'package:biller/page/add_customer_page.dart';
import 'package:biller/page/add_line_item_page.dart';
import 'package:biller/util/form_helper.dart';
import 'package:biller/util/route_generator.dart';
import 'package:flutter/material.dart';

class AddSaleOrderPage extends StatefulWidget {
  static const routeName = '/sale_order';

  @override
  _AddSaleOrderPageState createState() => _AddSaleOrderPageState();
}

class _AddSaleOrderPageState extends State<AddSaleOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'orderNo': TextEditingController(),
  };

  SaleOrderService _db;
  CustomerService _customerService;
  Customer _customer;
  List<SaleOrderItem> _orderItems = [];
  DateTime _orderedDate;
  String _error;

  @override
  void initState() {
    _db = SaleOrderService();
    _customerService = CustomerService();

    _orderedDate = DateTime.now();

    print(_orderedDate);

    _controllers['orderNo'].value = TextEditingValue(text: 'fetching SO no');
    _db.getSONumber().then((value) {
      _controllers['orderNo'].text = value;
    });
    super.initState();
  }

  void _handleSubmit(BuildContext context) {
    if (_customer == null) {
      setState(() {
        _error = 'Customer Requied';
      });
      return;
    }
    setState(() {
      _error = '';
    });

    if (_orderItems.isEmpty) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('No items added'),
        ),
      );
    }
    SaleOrder order = SaleOrder(
      items: _orderItems,
      status: 1,
      customer: _customer,
      orderNo: _controllers['orderNo'].text,
      orderedOn: _orderedDate,
    );

    _db.addSaleOrder(order).then((value) {
      SaleOrder _order = value;
      if (_order != null) {
        Navigator.of(context).pop(_order);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('New Sale Order'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: () => _handleSubmit(context),
            icon: Icon(Icons.save),
            label: Text('Save'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FormHelper.getFormCard(
              children: [
                FormHelper.getAutoCompleteField(
                  hint: "Customer",
                  headerAction: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AddCustomerPage.routeName)
                          .then((value) {
                        Customer customer = value;
                        if (customer != null) {
                          setState(() {
                            _customer = customer;
                          });
                        }
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                  decoration: FormHelper.getInputDecoration(
                    error: _error,
                    context: context,
                  ),
                  itemBuilder: (BuildContext context, itemData) {
                    Customer customer = itemData;
                    return ListTile(
                      title: Text(customer.customerName),
                    );
                  },
                  onSuggestionSelected: (itemData) {
                    Customer customer = itemData;
                    setState(() {
                      _customer = customer;
                    });
                  },
                  controller:
                      TextEditingController(text: _customer?.customerName),
                  suggestionsCallback: (pattern) {
                    if (_customer != null) _customer = null;

                    return _customerService.searchCustomer(pattern);
                  },
                ),
                FormHelper.getInputField(
                  controller: _controllers['orderNo'],
                  context: context,
                  hint: 'Order No',
                  disabled: true,
                  decoration: FormHelper.getInputDecoration(
                    context: context,
                  ),
                  validator: (String value) {
                    return null;
                  },
                ),
                FormHelper.getDatePicker(
                  context: context,
                  selectedDate: _orderedDate,
                  hint: 'Date',
                  onSelect: (DateTime date) {
                    setState(() {
                      _orderedDate = date;
                    });
                  },
                ),
              ],
            ),
            FormHelper.getFormCard(
              children: [
                Text(
                  'Line Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _orderItems.isNotEmpty
                    ? Table(children: [
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
                                        vertical: 10, horizontal: 16),
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                          ],
                        ),
                        ..._orderItems
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
                                          '${e.quantity} * ₹${e.price}',
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
                                      '₹${e.price * e.quantity}',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ])
                    : Container(),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text('Add Line Item'),
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(
                        AddLineItemPage.routeName,
                        arguments: LineItemArguments(
                          type: LineItemArgumentsType.saleOrder,
                        ),
                      )
                          .then((value) {
                        if (value != null)
                          setState(() {
                            _orderItems.add(value);
                          });
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
