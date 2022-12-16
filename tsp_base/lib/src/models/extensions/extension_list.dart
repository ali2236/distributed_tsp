extension Swap<T> on List<T> {
  void swap(int i, int j) {
    final first = this[i];
    final second = this[j];

    this[i] = second;
    this[j] = first;
  }
}
