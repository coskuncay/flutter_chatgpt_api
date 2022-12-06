class ExpiryMap<K, V> {
  final Map<K, V> _map = {};

  V? operator [](K key) => _map[key];

  void operator []=(K key, V value) {
    _map[key] = value;
    Future.delayed(const Duration(seconds: 10), () => _map.remove(key));
  }
}
