({T? result, Error? error}) runCatching<T>(T Function() toRun) {
  try {
    return (result: toRun(), error: null);
  }
  on Error catch (error) {
    return (result: null, error: error);
  }
}