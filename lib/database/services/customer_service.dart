import 'package:biller/database/model/data_model.dart';
import 'package:biller/database/model/mock_model.dart';
import 'package:biller/util/db_helper.dart';

class CustomerService {
  final String _baseSelectQuery = '''SELECT
        customers.id AS customer_id, * 
        FROM ${CustomerModel.table} ''';
  final String _baseDeleteQuery = '''DELETE FROM ${CustomerModel.table} ''';

  final String _customerTable = CustomerModel.table;

  Future<Customer> addCustomer(Customer customer) async {
    await DB.init();

    if (customer.customerName == null && customer.customerPhone == null)
      return null;

    CustomerModel customerModel = CustomerModel(
      customerName: customer.customerName,
      customerPhone: customer.customerPhone,
    );

    int inserted = await DB.insert(CustomerModel.table, customerModel);
    customerModel.id = inserted;

    return customerModel.toCustomer();
  }

  Future<List<Customer>> getCustomer() async {
    await DB.init();
    List<Map<String, dynamic>> customers = await DB.rawQuery('''SELECT
        customers.id AS customer_id, * 
        FROM $_customerTable ''');

    return customers
        .map((item) => CustomerModel.fromMap(item).toCustomer())
        .toList();
  }

  Future<List<Customer>> searchCustomer(String pattern) async {
    await DB.init();
    String _whereClause = (pattern.isEmpty
            ? ''
            : '''WHERE $_customerTable.customerName LIKE '$pattern%' ''') +
        ' LIMIT 5';

    List<Map<String, dynamic>> customers =
        await DB.rawQuery(_baseSelectQuery + _whereClause);
    return customers.map((e) => CustomerModel.fromMap(e).toCustomer()).toList();
  }

  Future<Customer> getCustomerById(int id) async {
    await DB.init();

    String _whereClause = '''
    WHERE $_customerTable.id = $id LIMIT 1
    ''';

    List<Map<String, dynamic>> customers =
        await DB.rawQuery(_baseSelectQuery + _whereClause);

    List customersList = customers
        .map((map) => CustomerModel.fromMap(map).toCustomer())
        .toList();

    return customersList[0];
  }

  Future<int> deleteCustomer(int id) async {
    await DB.init();

    String _whereClause = 'WHERE $_customerTable.id = $id';

    int count = await DB.rawDelete(_baseDeleteQuery + _whereClause);

    return count;
  }

  Future<List<SaleOrder>> getAllOrders(int id) {
    
  }
}
