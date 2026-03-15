import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addItem(CartItem newItem) {
    int index = _items.indexWhere((item) => item.bookId == newItem.bookId);
    if (index >= 0) {
      if (_items[index].quantity < _items[index].stock) {
        _items[index].quantity++;
      }
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void increaseQuantity(int bookId) {
    int index = _items.indexWhere((item) => item.bookId == bookId);
    if (index >= 0 && _items[index].quantity < _items[index].stock) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int bookId) {
    int index = _items.indexWhere((item) => item.bookId == bookId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(int bookId) {
    _items.removeWhere((item) => item.bookId == bookId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
