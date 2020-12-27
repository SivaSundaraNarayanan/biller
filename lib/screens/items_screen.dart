import 'package:biller/database/model/mock_model.dart';
import 'package:biller/database/services/item_service.dart';
import 'package:biller/page/add_items_page.dart';
import 'package:biller/screens/empty_screen.dart';
import 'package:flutter/material.dart';

class ItemsScreen extends StatefulWidget {
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  ItemService _db;

  Future<List<Item>> _itemFuture;

  @override
  void initState() {
    super.initState();
    _db = ItemService();

    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _itemFuture = _db.getItemsWithStock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _itemFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasData && snapshot.data.length > 0) {
            List<Item> items = snapshot.data;
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.grey[300],
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      Item item = items[index];

                      int availableCount =
                          item.stock.count - item.stock.committed;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {},
                          subtitle: Row(
                            children: [
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Available Stock: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '$availableCount ${item.unit}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: availableCount > 0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            item.itemName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[700],
                              ),
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: '₹ ${item.costPrice.ceil()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: items.length,
                  ),
                ),
              ],
            );
          }
          return EmptyScreen(
            title: 'Item',
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddItemsPage.routeName)
              .then((rebuild) {
            if (rebuild != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text('Item created successfully'),
                ),
              );
              _fetchData();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
