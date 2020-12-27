import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/item_service.dart';
import 'package:biller/util/form_helper.dart';
import 'package:biller/util/route_generator.dart';
import 'package:flutter/material.dart';

class AddLineItemPage extends StatefulWidget {
  static const routeName = '/add_line_items';

  final LineItemArgumentsType type;

  const AddLineItemPage({Key key, this.type}) : super(key: key);

  @override
  _AddLineItemPageState createState() => _AddLineItemPageState();
}

class _AddLineItemPageState extends State<AddLineItemPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controller = {
    'quantity': TextEditingController(text: '${1.toString()}'),
    'price': TextEditingController()
  };

  ItemService _db;

  Item _item;
  String _error;

  @override
  void initState() {
    _db = ItemService();
    super.initState();
  }

  _handleSubmit() {
    if (_item == null) {
      setState(() {
        _error = 'Item Required';
      });
      return;
    }
    setState(() {
      _error = null;
    });

    if (_formKey.currentState.validate()) {
      var orderItem;
      switch (this.widget.type) {
        case LineItemArgumentsType.saleOrder:
          orderItem = SaleOrderItem(
            item: _item,
            quantity: int.parse(_controller['quantity'].text),
            price: double.parse(_controller['price'].text),
          );
          break;
        case LineItemArgumentsType.purchaseOrder:
          orderItem = PurchaseOrderItem(
            item: _item,
            quantity: int.parse(_controller['quantity'].text),
            price: double.parse(_controller['price'].text),
          );
          break;
      }

      Navigator.of(context).pop(orderItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('New Line Item'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: _handleSubmit,
            icon: Icon(Icons.add),
            label: Text('Add'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FormHelper.getFormCard(
                children: [
                  FormHelper.getAutoCompleteField(
                    hint: "Item",
                    headerAction: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/item').then((value) {
                          Item item = value;
                          if (item != null) {
                            setState(() {
                              _item = item;
                            });
                            _controller['price'].text = '${item.costPrice}';
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
                      Item item = itemData;
                      if (this.widget.type == LineItemArgumentsType.saleOrder &&
                          item.stock.count == 0) {
                        return Container();
                      }
                      return ListTile(
                        title: Text(item.itemName),
                        subtitle: Container(
                          child: RichText(
                            text: TextSpan(
                              text: 'Available: ',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${item.stock.count - item.stock.committed} ${item.unit}',
                                  style: TextStyle(
                                    color: item.stock.count < 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                TextSpan(
                                  text: '   Price: ',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                TextSpan(
                                  text: '₹ ${item.costPrice}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (itemData) {
                      Item item = itemData;
                      _controller['price'].text = '${item.costPrice}';
                      setState(() {
                        _item = item;
                      });
                    },
                    controller: TextEditingController(text: _item?.itemName),
                    suggestionsCallback: (pattern) {
                      if (_item != null) _item = null;

                      return _db.searchItemsWithStock(pattern);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: FormHelper.getInputField(
                            context: context,
                            hint: 'Quantity',
                            controller: _controller['quantity'],
                            keyboardType: TextInputType.number,
                            decoration: FormHelper.getInputDecoration(
                              context: context,
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Quantity required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: FormHelper.getInputField(
                            context: context,
                            hint: 'Price',
                            controller: _controller['price'],
                            keyboardType: TextInputType.number,
                            decoration: FormHelper.getInputDecoration(
                              context: context,
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Price required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
