import 'package:biller/database/model/data_model.dart';
import 'package:biller/database/model/mock_model.dart';
import 'package:biller/util/db_helper.dart';

class SaleOrderService {
  Future<SaleOrder> addSaleOrder(SaleOrder order) async {
    await DB.init();

    SaleOrderModel model = SaleOrderModel(
      orderNo: order.orderNo,
      orderedOn: order.orderedOn,
      status: order.status,
      customerId: order.customer.id,
    );
    int inserted = await DB.insert(SaleOrderModel.table, model);

    if (inserted != null) {
      order.id = inserted;

      for (var itr = 0; itr < order.items.length; itr++) {
        SaleOrderItem element = order.items[itr];

        SaleOrderItemModel _orderItems = SaleOrderItemModel(
          quantity: element.quantity,
          price: element.price,
          orderId: inserted,
          itemId: element.item.id,
        );

        await DB.rawQuery('''
        UPDATE ${StockModel.table} 
        SET count = count - ${element.quantity} 
        WHERE itemId = ${element.item.id}
        ''');

        int _id = await DB.insert(SaleOrderItemModel.table, _orderItems);
        order.items[itr].id = _id;
      }
    }

    return order;
  }

  Future<List<SaleOrderModel>> getSaleOrder() async {
    await DB.init();
    List<Map<String, dynamic>> customers = await DB.query(SaleOrderModel.table);

    return customers.map((item) => SaleOrderModel.fromMap(item)).toList();
  }

  Future<String> getSONumber() async {
    await DB.init();
    String pre = 'SO-';

    var res = await DB.rawQuery('''
    SELECT orderNo FROM ${SaleOrderModel.table} ORDER BY id DESC LIMIT 1
    ''');

    if (res.isEmpty) return '$pre${1.toString().padLeft(3, '0')}';

    var prevOrderNo = int.parse(res[0]['orderNo'].toString().substring(3));

    var orderNo = '$pre${(prevOrderNo + 1).toString().padLeft(3, '0')}';

    return orderNo;
  }

  Future<List<SaleOrder>> getSaleOrderWithItems() async {
    await DB.init();

    List<Map<String, dynamic>> items = await DB.rawQuery('''SELECT 
        orders.id as order_id, order_items.id as order_item_id, items.id as item_id, stocks.id as stock_id, *
        from ${SaleOrderModel.table} orders 
        INNER JOIN ${SaleOrderItemModel.table} order_items ON order_items.orderId = orders.id 
        INNER JOIN ${ItemModel.table} items ON items.id = order_items.itemId
        INNER JOIN ${StockModel.table} stocks ON stocks.itemId = items.id
        ORDER BY orders.id''');

    List<SaleOrder> saleOrders = [];
    SaleOrder order;

    for (int itr = 0; itr < items.length; itr++) {
      var item = items[itr];

      if (itr == 0 || item['order_id'] != items[itr - 1]['order_id']) {
        if (itr != 0) saleOrders.add(order);

        order = SaleOrderModel.fromMap(item).toSaleOrder();
      }

      SaleOrderItem _orderItem =
          SaleOrderItemModel.fromMap(item).toSaleOrderItem();

      Item _item = ItemModel.fromMap(item).toItem();
      Stock _stock = StockModel.fromMap(item).toStock();

      _item.stock = _stock;
      _orderItem.item = _item;

      order.items.add(_orderItem);

      if (itr == items.length - 1) saleOrders.add(order);
    }

    return saleOrders;
  }
}
