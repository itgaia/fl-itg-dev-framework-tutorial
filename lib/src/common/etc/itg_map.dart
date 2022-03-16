/// Merges the values of the given maps together.
///
/// `recursive` is set to `true` by default. If set to `true`,
/// then nested maps will also be merged. Otherwise, nested maps
/// will overwrite others.
///
/// `acceptNull` is set to `false` by default. If set to `false`,
/// then if the value on a map is `null`, it will be ignored, and
/// that `null` will not be copied.
Map mergeMap(Iterable<Map> maps, {bool recursive = true, bool acceptNull = false}) {
  Map<String, Map<String, String>> result = {};
  // itgLogVerbose('[ItgMap.mergeMap] before merge...');
  for (var map in maps) {
    _copyValues(map, result, recursive, acceptNull);
  }
  // itgLogVerbose('[ItgMap.mergeMap] after merge - result: $result');
  return result;
}

_copyValues(Map from, Map to, bool recursive, bool acceptNull) {
  for (var key in from.keys) {
    if (from[key] is Map && recursive) {
      if (to[key] is! Map) {
        to[key] = <String, String>{};
      }
      _copyValues(from[key] as Map, to[key] as Map, recursive, acceptNull);
    } else {
      if (from[key] != null || acceptNull) to[key] = from[key];
    }
  }
}
