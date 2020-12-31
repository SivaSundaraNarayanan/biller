import 'package:biller/database/model/data_model.dart';
import 'package:biller/database/model/mock_model.dart';
import 'package:biller/util/db_helper.dart';

class SaleOrderService {
  final String _saleOrderTable = SaleOrderModel.table;
  final String _saleOrderItemTable = SaleOrderModel.table;

  final String _baseDeleteQuery = '''DELETE FROM ${SaleOrderModel.table} ''';

  final String _baseSelectQuery = 'SELECT' +
      ' orders.id as order_id, order_items.id as order_item_id, items.id as item_id, stocks.id as stock_id, customers.id as customer_id,*' +
      ' from ${SaleOrderModel.table} orders ';

  final String _joinQuery =
      'INNER JOIN ${SaleOrderItemModel.table} order_items ON order_items.orderId = orders.id ' +
          'INNER JOIN ${ItemModel.table} items ON items.id = order_items.itemId ' +
          'INNER JOIN ${StockModel.table} stocks ON stocks.itemId = items.id ' +
          'INNER JOIN ${CustomerModel.table} customers ON orders.customerId = customers.id ';

  final String _orderQuery = 'ORDER BY orders.id ';

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

    List<Map<String, dynamic>> items =
        await DB.rawQuery(_baseSelectQuery + _joinQuery + _orderQuery);

    List<SaleOrder> saleOrders = formatSaleOrder(items);

    return saleOrders;
  }

  Future<SaleOrder> getSaleOrderById(int id) async {
    await DB.init();

    String whereClause = ' WHERE order_id = $id ';

    var query = _baseSelectQuery + _joinQuery + whereClause + _orderQuery;

    List<Map<String, dynamic>> items = await DB.rawQuery(query);

    List<SaleOrder> orders = formatSaleOrder(items);

    return orders[0];
  }

  Future<bool> deleteSaleOrder(int id) async {
    await DB.init();

    String whereClause = ' WHERE id = $id';

    int count = await DB.rawDelete(_baseDeleteQuery + whereClause);

    return count == 1;
  }

  static List<SaleOrder> formatSaleOrder(List<Map<String, dynamic>> items) {
    List<SaleOrder> saleOrders = [];
    SaleOrder order;

    for (int itr = 0; itr < items.length; itr++) {
      var item = items[itr];

      if (itr == 0 || item['order_id'] != items[itr - 1]['order_id']) {
        if (itr != 0) saleOrders.add(order);

        order = SaleOrderModel.fromMap(item).toSaleOrder();
        Customer _customer = CustomerModel.fromMap(item).toCustomer();
        order.customer = _customer;
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

  Future<List<SaleOrder>> getSaleOrderByCustomerId(int id) async {
    await DB.init();

    String whereClause = 'WHERE customers.id = $id';

    String orderBy = ' ORDER BY date(orders.orderedOn) DESC';

    List<Map<String, dynamic>> items = await DB
        .rawQuery(_baseSelectQuery + _joinQuery + whereClause + orderBy);

    var orders = formatSaleOrder(items);

    return orders;
  }
}
