import 'dart:io';

class MenuItem {
  String name;
  double price;
  String category;

  MenuItem(this.name, this.price, this.category);

  @override
  String toString() {
    return 'Name: $name, Price: $price, Category: $category';
  }
}

class Order {
  late String orderId;
  late int tableNumber;
  late List<MenuItem> items;
  late bool isCompleted;

  Order(this.orderId, this.tableNumber) {
    items = [];
    isCompleted = false;
  }

  void addItem(MenuItem item) {
    items.add(item);
  }

  void removeItem(MenuItem item) {
    items.remove(item);
  }

  void completeOrder() {
    isCompleted = true;
  }

  @override
  String toString() {
    return 'OrderId: $orderId, Table: $tableNumber, Items: ${items.join(', ')}, Completed: $isCompleted';
  }
}

class Restaurant {
  late List<MenuItem> menu;
  late List<Order> orders;
  late List<bool> tables;

  Restaurant(int numberOfTables) {
    menu = [];
    orders = [];
    tables = List.filled(numberOfTables, false);
  }

  void addMenuItem(MenuItem item) {
    menu.add(item);
  }

  void removeMenuItem(MenuItem item) {
    menu.remove(item);
  }

  void placeOrder(Order order) {
    orders.add(order);
    tables[order.tableNumber] = true;
  }

  void completeOrder(String orderId) {
    Order order = orders.firstWhere((order) => order.orderId == orderId);
    order.completeOrder();
    tables[order.tableNumber] = false;
  }

  MenuItem getMenuItem(String name) {
    return menu.firstWhere((item) => item.name == name);
  }

  Order getOrder(String orderId) {
    return orders.firstWhere((order) => order.orderId == orderId);
  }
}

void main() {
  Restaurant restaurant = Restaurant(10);

  while (true) {
    print('\n[ Restaurant ]');
    print('1. Menu Item');
    print('2. Order');
    print('3. Search');
    print('Q. Exit');
    stdout.write('Please enter your choice (1–3 or Q): ');
    String? choice = stdin.readLineSync();

    if (choice == 'Q' || choice == 'q') {
      break;
    }

    switch (choice) {
      case '1':
        manageMenu(restaurant);
        break;
      case '2':
        manageOrder(restaurant);
        break;
      case '3':
        searchItem(restaurant);
        break;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

void manageMenu(Restaurant restaurant) {
  while (true) {
    print('\n[ Menu ]');
    print('1. Add');
    print('2. Remove');
    print('3. List All Items');
    print('0. Back');
    stdout.write('Please enter your choice (1–3 or 0): ');
    String? choice = stdin.readLineSync();

    if (choice == '0') {
      break;
    }

    switch (choice) {
      case '1':
        addMenuItem(restaurant);
        break;
      case '2':
        removeMenuItem(restaurant);
        break;
      case '3':
        listMenuItems(restaurant);
        break;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

void addMenuItem(Restaurant restaurant) {
  stdout.write('Add new menu item\nName: ');
  String? name = stdin.readLineSync();
  stdout.write('Price: ');
  String? priceInput = stdin.readLineSync();
  double price = double.parse(priceInput ?? '0');
  stdout.write('Category (M=Main course, D=Dessert, W=Drink): ');
  String? category = stdin.readLineSync();

  MenuItem item = MenuItem(name ?? '', price, category ?? '');
  
  print('\nAdd name = [$name]');
  print('  price = [$price]');
  print('  Category = [$category]');
  stdout.write('Press Y to confirm: ');
  String? confirm = stdin.readLineSync();
  if (confirm != null && confirm.toLowerCase() == 'y') {
    restaurant.addMenuItem(item);
    print('Item added successfully.');
  } else {
    print('Item not added.');
  }

  // Display the updated menu
  listMenuItems(restaurant);
}

void removeMenuItem(Restaurant restaurant) {
  stdout.write('Enter the name of the menu item to remove: ');
  String? name = stdin.readLineSync();

  MenuItem? item = restaurant.menu.firstWhere((item) => item.name == name, orElse: () => MenuItem('', 0, ''));
  
  if (item.name != '') {
    restaurant.removeMenuItem(item);
    print('Item removed successfully.');
  } else {
    print('Item not found.');
  }

  // Display the updated menu
  listMenuItems(restaurant);
}

void listMenuItems(Restaurant restaurant) {
  print('\nCurrent Menu:');
  for (MenuItem menuItem in restaurant.menu) {
    print(menuItem);
  }
}

void manageOrder(Restaurant restaurant) {
  while (true) {
    print('\n[ Order ]');
    print('1. Place Order');
    print('2. Complete Order');
    print('3. List All Orders');
    print('0. Back');
    stdout.write('Please enter your choice (1–3 or 0): ');
    String? choice = stdin.readLineSync();

    if (choice == '0') {
      break;
    }

    switch (choice) {
      case '1':
        placeOrder(restaurant);
        break;
      case '2':
        completeOrder(restaurant);
        break;
      case '3':
        listOrders(restaurant);
        break;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

void placeOrder(Restaurant restaurant) {
  stdout.write('Enter Order ID: ');
  String? orderId = stdin.readLineSync();
  stdout.write('Enter Table Number: ');
  String? tableNumberInput = stdin.readLineSync();
  int tableNumber = int.parse(tableNumberInput ?? '0');

  Order order = Order(orderId ?? '', tableNumber);

  while (true) {
    stdout.write('Enter menu item name to add (or type "done" to finish): ');
    String? itemName = stdin.readLineSync();
    if (itemName == 'done') {
      break;
    }

    try {
      MenuItem item = restaurant.getMenuItem(itemName ?? '');
      order.addItem(item);
      print('Item added to order.');
    } catch (e) {
      print('Item not found.');
    }
  }

  restaurant.placeOrder(order);
  print('Order placed successfully.');

  // Display the updated orders
  listOrders(restaurant);
}

void completeOrder(Restaurant restaurant) {
  stdout.write('Enter Order ID to complete: ');
  String? orderId = stdin.readLineSync();

  try {
    restaurant.completeOrder(orderId ?? '');
    print('Order completed successfully.');
  } catch (e) {
    print('Order not found.');
  }

  // Display the updated orders
  listOrders(restaurant);
}

void listOrders(Restaurant restaurant) {
  print('\nCurrent Orders:');
  for (Order order in restaurant.orders) {
    print(order);
  }
}

void searchItem(Restaurant restaurant) {
  stdout.write('Enter item name to search: ');
  String? name = stdin.readLineSync();

  MenuItem? item = restaurant.menu.firstWhere((item) => item.name == name, orElse: () => MenuItem('', 0, ''));
  
  if (item.name != '') {
    print('Item found: $item');
  } else {
    print('Item not found.');
  }
}
