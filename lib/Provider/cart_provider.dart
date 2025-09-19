import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spotifymusic_app/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<Producto> _cart = [];
  List<Producto> get cart => _cart;
  

  void toggleFavorite(Producto producto) {
    if (_cart.contains(producto)) {
      for (Producto element in _cart) {
        element.quantity++;
      }
      _cart.remove(producto);
    } else {
      _cart.add(producto);
    }
    notifyListeners();
  }

  void incrementoQtn(int index) {
    _cart[index].quantity++;
    notifyListeners();
  }

  void decrementoQtn(int index) {
    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    }
    notifyListeners();
  }
  void clearCart() {
    cart.clear();
    notifyListeners();
  }
  void removeFromCart(int index) {
  cart.removeAt(index);
  notifyListeners();
  }
 

  /// ✅ Método para obtener el primer producto del carrito
  Producto? getFirstProduct() {
    if (_cart.isNotEmpty) {
      return _cart.first;
    }
    return null;
  }

  static CartProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<CartProvider>(
      context,
      listen: listen,
    );
  }
}
