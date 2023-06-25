class Optional<T> {
  T? _value;

  Optional(this._value);

  Optional.empty() {
    _value = null;
  }

  Optional<E> map<E>(E? Function(T value) provider) {
    return isPresent ? Optional(provider(_value as T)) : Optional<E>.empty();
  }

  T orElse(T Function() provider) {
    return isPresent ? _value as T : provider();
  }

  T get() {
    if (isPresent) {
      return _value as T;
    }

    throw EmptyOptionalValue();
  }

  void onIf({void Function(T value)? onPresent, void Function()? onEmpty}) {
    if (onPresent != null) {
      ifPresent(onPresent);
    }
    if (onEmpty != null) {
      ifEmpty(onEmpty);
    }
  }

  void ifPresent(void Function(T value) fn) {
    if (!isPresent) return;
    fn(_value as T);
  }

  void ifEmpty(void Function() fn) {
    if (isPresent) return;
    fn();
  }

  bool get isPresent => _value != null;
}

extension OptionalExtension<T> on T? {
  Optional<T> asOptional() {
    return Optional(this);
  }
}

class EmptyOptionalValue extends Error {}