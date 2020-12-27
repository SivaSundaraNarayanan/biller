import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/customer_service.dart';
import 'package:biller/util/form_helper.dart';
import 'package:flutter/material.dart';

class AddCustomerPage extends StatefulWidget {
  static const routeName = '/customer';

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'name': new TextEditingController(),
    'phone': new TextEditingController(),
  };

  CustomerService _db;

  @override
  void initState() {
    super.initState();

    _db = CustomerService();
  }

  void _handleSubmit() {
    String name = _controllers['name'].text;
    String phone = '+91 ' + _controllers['phone'].text;

    if (_formKey.currentState.validate()) {
      Customer customer = Customer(
        customerName: name,
        customerPhone: phone,
      );

      _db.addCustomer(customer).then((value) {
        if (value != null) {
          Navigator.of(context).pop(value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('New Customer'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: _handleSubmit,
            icon: Icon(Icons.save),
            label: Text('Save'),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormHelper.getFormCard(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    FormHelper.getInputField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name is Required';
                        }
                        return null;
                      },
                      context: context,
                      controller: _controllers['name'],
                      hint: 'Name',
                      decoration: FormHelper.getInputDecoration(
                        context: context,
                      ),
                    ),
                    FormHelper.getInputField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Phone number is required';
                        } else if (value.length < 10) {
                          return 'Enter valid Phone number';
                        }
                        return null;
                      },
                      context: context,
                      controller: _controllers['phone'],
                      hint: 'Phone',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: FormHelper.getInputDecoration(
                        prefix: Text('+91 - '),
                        context: context,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
