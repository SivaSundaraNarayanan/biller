class Customer {
  int id;
  String customerName;
  String customerPhone;

  Customer({
    this.id,
    this.customerName,
    this.customerPhone,
  });
}

class Item {
  int id;
  String itemName;
  String itemDescription;
  double costPrice;
  double charges;
  String unit;
  double discount;
  Stock stock;

  Item({
    this.id,
    this.itemName,
    this.itemDescription,
    this.costPrice,
    this.charges,
    this.unit,
    this.discount,
    this.stock,
  });
}

class Stock {
  int id;
  int count;
  int committed;

  Stock({
    this.id,
    this.committed,
    this.count,
  });
}

class PurchaseOrder {
  int id;
  List<PurchaseOrderItem> items;
  int status;
  String orderNo;
  DateTime orderedOn;

  PurchaseOrder({
    this.orderNo,
    this.orderedOn,
    this.status,
    this.id,
    this.items,
  });
}

class PurchaseOrderItem {
  int id;
  Item item;
  int quantity;
  double price;

  PurchaseOrderItem({
    this.id,
    this.item,
    this.price,
    this.quantity,
  });
}

class SaleOrder {
  int id;
  List<SaleOrderItem> items;
  int status;
  String orderNo;
  Customer customer;
  DateTime orderedOn;

  SaleOrder({
    this.orderNo,
    this.orderedOn,
    this.status,
    this.id,
    this.items,
    this.customer,
  });
}

class SaleOrderItem {
  int id;
  Item item;
  int quantity;
  double price;

  SaleOrderItem({
    this.id,
    this.item,
    this.price,
    this.quantity,
  });
}
