import 'dart:developer';

import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/item_service.dart';
import 'package:biller/util/constant_helper.dart';
import 'package:biller/util/form_helper.dart';
import 'package:flutter/material.dart';

const _dropDownOptions = ['Boxes', 'Pieces'];

class AddItemsPage extends StatefulWidget {
  static const routeName = '/item';

  @override
  _AddItemsPageState createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  String _unit = _dropDownOptions[0];

  final Map<String, TextEditingController> _controllers = {
    'itemName': new TextEditingController(),
    'itemDescription': new TextEditingController(),
    'costPrice': new TextEditingController(),
    'charges': new TextEditingController(),
    'discount': new TextEditingController(),
    'stock': new TextEditingController(),
  };

  ItemService _db;

  void _handleSubmit() {
    Item item = Item(
      itemName: _controllers['itemName'].text,
      itemDescription: _controllers['itemDescription'].text,
      costPrice: double.parse(_controllers['costPrice'].text),
      charges: double.parse(_controllers['charges'].text) ?? 0,
      discount: double.parse(_controllers['discount'].text) ?? 0,
      unit: _unit,
      stock: Stock(
        count: int.parse(_controllers['stock'].text) ?? 0,
      ),
    );

    _db.addItem(item).then((value) {
      if (value != null) Navigator.of(context).pop(value);
    });
  }

  @override
  void initState() {
    super.initState();

    _initTextFields();

    _db = ItemService();
  }

  void _initTextFields() {
    _controllers['stock'].value = TextEditingValue(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('New Item'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: _handleSubmit,
            icon: Icon(Icons.save),
            label: Text('Save'),
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormHelper.getFormCard(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  FormHelper.getInputField(
                    context: context,
                    controller: _controllers['itemName'],
                    hint: 'Item Name',
                    decoration: FormHelper.getInputDecoration(
                      context: context,
                    ),
                  ),
                  FormHelper.getInputField(
                    context: context,
                    controller: _controllers['itemDescription'],
                    hint: 'Item Description',
                    multilines: true,
                    decoration: FormHelper.getInputDecoration(
                      context: context,
                    ),
                  ),
                ],
              ),
              FormHelper.getFormCard(
                children: [
                  Text(
                    'Price Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FormHelper.getInputField(
                    context: context,
                    controller: _controllers['costPrice'],
                    hint: 'Cost Price',
                    keyboardType: TextInputType.number,
                    decoration: FormHelper.getInputDecoration(
                      prefix: Text('${ConstantHelper.rupeeSymbol} '),
                      context: context,
                    ),
                  ),
                  FormHelper.getInputField(
                    context: context,
                    controller: _controllers['charges'],
                    hint: 'Charges',
                    keyboardType: TextInputType.number,
                    decoration: FormHelper.getInputDecoration(
                      prefix: Text('${ConstantHelper.rupeeSymbol} '),
                      context: context,
                    ),
                  ),
                  FormHelper.getInputField(
                    context: context,
                    controller: _controllers['discount'],
                    hint: 'Discount',
                    keyboardType: TextInputType.number,
                    decoration: FormHelper.getInputDecoration(
                      suffix: Text('%'),
                      context: context,
                    ),
                  ),
                ],
              ),
              FormHelper.getFormCard(
                children: [
                  Text(
                    'Stock Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FormHelper.getInputField(
                    hint: 'Opening Stock',
                    context: context,
                    controller: _controllers['stock'],
                    keyboardType: TextInputType.number,
                    decoration: FormHelper.getInputDecoration(
                      context: context,
                    ),
                  ),
                  FormHelper.getDropDownField(
                    context: context,
                    // controller: _controllers['name'],
                    hint: 'Unit',
                    items: _dropDownOptions
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList(),
                    value: _unit,
                    onChanged: (e) {
                      setState(() {
                        _unit = e;
                      });
                    },
                    decoration: FormHelper.getInputDecoration(
                      context: context,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
