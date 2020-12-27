import 'package:biller/database/model/data_model.dart';
import 'package:biller/database/model/mock_model.dart';
import 'package:biller/util/db_helper.dart';

class PurchaseOrderService {
  Future<PurchaseOrder> addPurchaseOrder(PurchaseOrder order) async {
    await DB.init();

    PurchaseOrderModel model = PurchaseOrderModel(
      orderNo: order.orderNo,
      orderedOn: order.orderedOn,
      status: order.status,
    );
    int inserted = await DB.insert(PurchaseOrderModel.table, model);

    if (inserted != null) {
      order.id = inserted;

      for (var itr = 0; itr < order.items.length; itr++) {
        PurchaseOrderItem element = order.items[itr];

        PurchaseOrderItemModel _orderItems = PurchaseOrderItemModel(
          quantity: element.quantity,
          price: element.price,
          orderId: inserted,
          itemId: element.item.id,
        );

        await DB.rawQuery('''
        UPDATE ${StockModel.table} 
        SET count = count + ${element.quantity} 
        WHERE itemId = ${element.item.id}
        ''');

        int _id = await DB.insert(PurchaseOrderItemModel.table, _orderItems);
        order.items[itr].id = _id;
      }
    }

    return order;
  }

  Future<List<PurchaseOrderModel>> getPurchaseOrder() async {
    await DB.init();
    List<Map<String, dynamic>> customers =
        await DB.query(PurchaseOrderModel.table);

    return customers.map((item) => PurchaseOrderModel.fromMap(item)).toList();
  }

  Future<String> getPONumber() async {
    await DB.init();
    String pre = 'PO-';

    var res = await DB.rawQuery('''
    SELECT orderNo FROM ${PurchaseOrderModel.table} ORDER BY id DESC LIMIT 1
    ''');

    if (res.isEmpty) return '$pre${1.toString().padLeft(3, '0')}';

    var prevOrderNo = int.parse(res[0]['orderNo'].toString().substring(3));

    var orderNo = '$pre${(prevOrderNo + 1).toString().padLeft(3, '0')}';

    return orderNo;
  }

  Future<List<PurchaseOrder>> getPurchaseOrderWithItems() async {
    await DB.init();

    List<Map<String, dynamic>> items = await DB.rawQuery('''SELECT 
        orders.id as order_id, order_items.id as order_item_id, items.id as item_id, stocks.id as stock_id, *
        from ${PurchaseOrderModel.table} orders 
        INNER JOIN ${PurchaseOrderItemModel.table} order_items ON order_items.orderId = orders.id 
        INNER JOIN ${ItemModel.table} items ON items.id = order_items.itemId
        INNER JOIN ${StockModel.table} stocks ON stocks.itemId = items.id
        ORDER BY orders.id''');

    List<PurchaseOrder> purchaseOrders = [];
    PurchaseOrder order;

    for (int itr = 0; itr < items.length; itr++) {
      var item = items[itr];

      if (itr == 0 || item['order_id'] != items[itr - 1]['order_id']) {
        if (itr != 0) purchaseOrders.add(order);

        order = PurchaseOrderModel.fromMap(item).toPurchaseOrder();
      }

      PurchaseOrderItem _orderItem =
          PurchaseOrderItemModel.fromMap(item).toPurchaseOrderItem();

      Item _item = ItemModel.fromMap(item).toItem();
      Stock _stock = StockModel.fromMap(item).toStock();

      _item.stock = _stock;
      _orderItem.item = _item;

      order.items.add(_orderItem);

      if (itr == items.length - 1) purchaseOrders.add(order);
    }

    return purchaseOrders;
  }
}
