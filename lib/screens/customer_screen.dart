import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/customer_service.dart';
import 'package:biller/page/add_customer_page.dart';
import 'package:biller/page/customer_details_page.dart';
import 'package:biller/screens/empty_screen.dart';
import 'package:biller/util/route_generator.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  CustomerService _db;
  Future<List<Customer>> _futureData;

  @override
  void initState() {
    super.initState();
    _db = new CustomerService();
    this._fetchData();
  }

  void _fetchData() {
    setState(() {
      _futureData = _db.getCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Customer>>(
        builder:
            (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasData && snapshot.data.length > 0) {
            List<Customer> customers = snapshot.data;

            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (BuildContext context, int index) {
                final Customer customer = customers[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(
                        CustomerDetailsPage.routeName,
                        arguments:
                            CustomerDetailArgument(customerId: customer.id),
                      )
                          .then((value) {
                        if (value != null) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: Text('Customer deleted successfully'),
                            ),
                          );
                          _fetchData();
                        }
                      });
                    },
                    title: Text(
                      customer.customerName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text('${customer.customerPhone}'),
                  ),
                );
              },
            );
          }
          return EmptyScreen(title: 'Customer');
        },
        future: _futureData,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddCustomerPage.routeName)
              .then((rebuild) {
            if (rebuild != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text('Customer created successfully'),
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
