// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

class _Env {
  static const List<int> _enviedkeytoken = [
    2259568975,
    3470922057,
    670702311,
    3180340132,
    3192639798,
    1360957323,
    3081375082,
    2870923341,
    4108725980,
    1562164635,
    2375765617,
    274240794,
    2596434586,
    337075386,
    1741790411
  ];
  static const List<int> _envieddatatoken = [
    2259568942,
    3470922023,
    670702227,
    3180340173,
    3192639827,
    1360957437,
    3081374981,
    2870923297,
    4108725929,
    1562164719,
    2375765528,
    274240885,
    2596434676,
    337075419,
    1741790375
  ];
  static final String token = String.fromCharCodes(
    List.generate(_envieddatatoken.length, (i) => i, growable: false)
        .map((i) => _envieddatatoken[i] ^ _enviedkeytoken[i])
        .toList(growable: false),
  );
}
