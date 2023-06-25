extension OptionalUtils<T> on T? {
  E? mapNullish<E>(E Function(T value) provider) {
    return isPresent ? null : provider(this as T);
  }
}

extension AllUtils<T> on T {
  T also(void Function(T value) fn) {
    fn(this);
    return this;
  }

  E mapTo<E>(E Function(T value) provider) {
    return provider(this);
  }

  /// Whether the value is present
  bool get isPresent => this != null;
}

extension StringUtils on String {
  String append(String otherString) {
    return this + otherString;
  }

  String prepend(String otherString) {
    return otherString + this;
  }
}

extension OptionalStringUtils on String? {
  bool get isPresentAndNotEmpty => isPresent && (this as String).isNotEmpty;
}