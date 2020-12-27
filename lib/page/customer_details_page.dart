import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsPage extends StatefulWidget {
  static const routeName = '/customer_detail';
  final int id;

  const CustomerDetailsPage({Key key, @required this.id}) : super(key: key);

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  CustomerService _customerService;
  Customer _customer;

  @override
  void initState() {
    _customerService = CustomerService();

    _customerService.getCustomerById(this.widget.id).then((value) {
      setState(() {
        _customer = value;
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
    final key = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: key,
      appBar: AppBar(
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
      body: Container(
        width: double.infinity,
        child: _customer != null
            ? Column(
                children: [
                  Card(
                    child: Row(
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
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
