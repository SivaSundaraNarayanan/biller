import 'package:biller/database/model/mock_model.dart';

class CustomerModel {
  static String table = 'customers';

  int id;
  String customerName;
  String customerPhone;

  CustomerModel({
    this.id,
    this.customerName,
    this.customerPhone,
  });

  static CustomerModel fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['customer_id'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
    };
    return map;
  }

  Customer toCustomer() {
    return Customer(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
    );
  }
}

class ItemModel {
  static String table = 'items';

  int id;
  String itemName;
  String itemDescription;
  double costPrice;
  double charges;
  String unit;
  double discount;

  ItemModel({
    this.id,
    this.itemName,
    this.itemDescription,
    this.costPrice,
    this.charges,
    this.unit,
    this.discount,
  });

  static ItemModel fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['item_id'],
      itemName: map['itemName'],
      itemDescription: map['itemDescription'],
      costPrice: map['costPrice'],
      charges: map['charges'],
      unit: map['unit'],
      discount: map['discount'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'costPrice': costPrice,
      'charges': charges,
      'unit': unit,
      'discount': discount,
    };
    return map;
  }

  Item toItem() {
    Item item = Item(
      id: id,
      itemName: itemName,
      itemDescription: itemDescription,
      costPrice: costPrice,
      charges: charges,
      unit: unit,
      discount: discount,
    );

    return item;
  }
}

class StockModel {
  static String table = 'stocks';

  int id;
  int count;
  int itemId;
  int committed;

  StockModel({
    this.id,
    this.count = 0,
    this.itemId,
    this.committed = 0,
  });

  static StockModel fromMap(Map<String, dynamic> map) {
    return StockModel(
      id: map['stock_id'],
      count: map['count'],
      itemId: map['itemId'],
      committed: map['committed'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'count': count,
      'committed': committed,
      'itemId': itemId,
    };
    return map;
  }

  Stock toStock() {
    return Stock(
      id: id,
      count: count,
      committed: committed,
    );
  }
}

class PurchaseOrderModel {
  static String table = 'purchase_orders';

  int id;
  String orderNo;
  int status;
  DateTime orderedOn;

  PurchaseOrderModel({
    this.id,
    this.orderNo,
    this.status,
    this.orderedOn,
  });

  static PurchaseOrderModel fromMap(Map<String, dynamic> map) {
    return PurchaseOrderModel(
      id: map['order_id'],
      orderNo: map['orderNo'],
      status: map['status'],
      orderedOn: DateTime.parse(map['orderedOn'] ?? DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'orderNo': orderNo,
      'status': status,
      'orderedOn': orderedOn.toString(),
    };
    return map;
  }

  PurchaseOrder toPurchaseOrder() {
    return PurchaseOrder(
      id: id,
      orderNo: orderNo,
      orderedOn: orderedOn,
      status: status,
      items: [],
    );
  }
}

class PurchaseOrderItemModel {
  static String table = 'purchase_order_items';

  int id;
  int itemId;
  int orderId;
  int quantity;
  double price;

  PurchaseOrderItemModel({
    this.id,
    this.quantity,
    this.price,
    this.itemId,
    this.orderId,
  });

  static PurchaseOrderItemModel fromMap(Map<String, dynamic> map) {
    return PurchaseOrderItemModel(
      id: map['order_item_id'],
      itemId: map['itemId'],
      orderId: map['orderId'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'itemId': itemId,
      'orderId': orderId,
      'quantity': quantity,
      'price': price,
    };
    return map;
  }

  PurchaseOrderItem toPurchaseOrderItem() {
    return PurchaseOrderItem(
      id: id,
      quantity: quantity,
      price: price,
    );
  }
}

class SaleOrderModel {
  static String table = 'sale_orders';

  int id;
  String orderNo;
  int status;
  DateTime orderedOn;
  int customerId;

  SaleOrderModel({
    this.id,
    this.orderNo,
    this.status,
    this.orderedOn,
    this.customerId,
  });

  static SaleOrderModel fromMap(Map<String, dynamic> map) {
    return SaleOrderModel(
      id: map['order_id'],
      orderNo: map['orderNo'],
      status: map['status'],
      orderedOn: DateTime.parse(
        map['orderedOn'] ?? DateTime.now(),
      ),
      customerId: map['customerId'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'orderNo': orderNo,
      'status': status,
      'orderedOn': orderedOn.toString(),
      'customerId': customerId,
    };
    return map;
  }

  SaleOrder toSaleOrder() {
    return SaleOrder(
      id: id,
      orderNo: orderNo,
      orderedOn: orderedOn,
      status: status,
      items: [],
    );
  }
}

class SaleOrderItemModel {
  static String table = 'sale_order_items';

  int id;
  int itemId;
  int orderId;
  int quantity;
  double price;

  SaleOrderItemModel({
    this.id,
    this.quantity,
    this.price,
    this.itemId,
    this.orderId,
  });

  static SaleOrderItemModel fromMap(Map<String, dynamic> map) {
    return SaleOrderItemModel(
      id: map['order_item_id'],
      itemId: map['itemId'],
      orderId: map['orderId'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'itemId': itemId,
      'orderId': orderId,
      'quantity': quantity,
      'price': price,
    };
    return map;
  }

  SaleOrderItem toSaleOrderItem() {
    return SaleOrderItem(
      id: id,
      quantity: quantity,
      price: price,
    );
  }
}
