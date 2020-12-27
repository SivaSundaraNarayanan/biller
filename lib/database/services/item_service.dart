import 'package:biller/database/model/data_model.dart';
import 'package:biller/database/model/mock_model.dart';
import 'package:biller/util/db_helper.dart';

class ItemService {
  Future<Item> addItem(Item item) async {
    await DB.init();

    if (item == null) return null;

    ItemModel itemModel = ItemModel(
      itemName: item.itemName,
      itemDescription: item.itemDescription,
      costPrice: item.costPrice,
      charges: item.charges,
      unit: item.unit,
      discount: item.discount,
    );

    var itemId = (await DB.insert(ItemModel.table, itemModel));
    bool isSaved = itemId.runtimeType == int;

    if (isSaved) {
      StockModel stockModel =
          StockModel(count: item.stock.count, itemId: itemId);

      isSaved =
          (await DB.insert(StockModel.table, stockModel)).runtimeType == int;
    }

    return (() {
      item.id = itemId;
      return item;
    })();
  }

  Future<List<Item>> getItemsWithStock() async {
    await DB.init();
    List<Map<String, dynamic>> items = await DB.rawQuery(
        'SELECT items.id AS item_id, stocks.id AS stock_id, * FROM items INNER JOIN stocks ON stocks.itemId = items.id');

    return items.map((e) {
      ItemModel itemModel = ItemModel.fromMap(e);
      StockModel stockModel = StockModel.fromMap(e);
      Item item = itemModel.toItem();
      item.stock = stockModel.toStock();
      return item;
    }).toList();
  }

  Future<List<Item>> searchItemsWithStock(String pattern) async {
    await DB.init();
    String _baseQuery = '''SELECT
        items.id AS item_id, stocks.id AS stock_id, * 
        FROM items ''';

    String _whereClause =
        (pattern.isEmpty ? '' : '''WHERE items.itemName LIKE '$pattern%' ''') +
            ' LIMIT 5';

    String _joinClause = '''INNER JOIN stocks ON stocks.itemId = items.id
        ''';

    List<Map<String, dynamic>> items =
        await DB.rawQuery(_baseQuery + _joinClause + _whereClause);

    return items.map((e) {
      ItemModel itemModel = ItemModel.fromMap(e);
      StockModel stockModel = StockModel.fromMap(e);
      Item item = itemModel.toItem();
      item.stock = stockModel.toStock();
      return item;
    }).toList();
  }
}
