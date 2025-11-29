import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spotifymusic_app/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<Producto> _cart = [];
  final List<String> _notifications = [];
  final Set<String> _downloadedBookIds = {}; // 👈 controla descargas duplicadas
 
  List<String> notifications = [];
  List<Producto> get cart => _cart;
 

  /// 👉 AGREGA UN PRODUCTO SIN DUPLICAR
  void addToCart(Producto producto) {
    final index = _cart.indexWhere((p) => p.id == producto.id);

    if (index == -1) {
      _cart.add(producto);
    } else {
      _cart[index].quantity++;
    }

    notifyListeners();
  }

  /// ✅ VERIFICA SI EL LIBRO YA FUE DESCARGADO
  bool isBookDownloaded(String bookId) {
    return _downloadedBookIds.contains(bookId);
  }

  /// ✅ REGISTRA LIBRO COMO DESCARGADO
  void markAsDownloaded(String bookId) {
    _downloadedBookIds.add(bookId);
    notifyListeners();
  }

  /// 👉 ELIMINA NOTIFICACIÓN POR ÍNDICE
  void removeNotificationAt(int index) {
  notifications.removeAt(index);
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
    for (var p in _cart) {
      p.quantity = 1; // Reinicia cada cantidad
    }
    _cart.clear();
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  Producto? getFirstProduct() {
    if (_cart.isNotEmpty) return _cart.first;
    return null;
  }

  /// 👉 AÑADIR NOTIFICACIÓN
  void addNotification(String message) {
  notifications.insert(0, message);
  notifyListeners();
}

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  /// ♻ Limpia historial de descargas si lo necesitas
  void clearDownloadedBooks() {
    _downloadedBookIds.clear();
    notifyListeners();
  }

  static CartProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartProvider>(context, listen: listen);
  }
}
