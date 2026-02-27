import 'package:flutter/foundation.dart';

/// Manages user's favourite product IDs.
class FavouritesProvider extends ChangeNotifier {
  final Set<int> _favourites = {};

  Set<int> get favourites => Set.unmodifiable(_favourites);

  bool isFavourite(int productId) => _favourites.contains(productId);

  void toggle(int productId) {
    if (_favourites.contains(productId)) {
      _favourites.remove(productId);
    } else {
      _favourites.add(productId);
    }
    notifyListeners();
  }
}
