// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chsDaoHash() => r'5afa478e53451d86db25fcdf2a5cf8787c7c5a22';

/// See also [chsDao].
@ProviderFor(chsDao)
final chsDaoProvider = AutoDisposeProvider<CHSDao>.internal(
  chsDao,
  name: r'chsDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chsDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChsDaoRef = AutoDisposeProviderRef<CHSDao>;
String _$chsCalculatorServiceHash() =>
    r'ea8f3412fa9d8702ddc32f6ed7b5f57cd058e552';

/// See also [chsCalculatorService].
@ProviderFor(chsCalculatorService)
final chsCalculatorServiceProvider =
    AutoDisposeProvider<CHSCalculatorService>.internal(
      chsCalculatorService,
      name: r'chsCalculatorServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chsCalculatorServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChsCalculatorServiceRef = AutoDisposeProviderRef<CHSCalculatorService>;
String _$chsHistoryHash() => r'2cfb2e4dc857e199d36b2118960b4363b3e02e25';

/// See also [chsHistory].
@ProviderFor(chsHistory)
final chsHistoryProvider =
    AutoDisposeFutureProvider<List<CompanionHealthScore>>.internal(
      chsHistory,
      name: r'chsHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chsHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChsHistoryRef =
    AutoDisposeFutureProviderRef<List<CompanionHealthScore>>;
String _$cHSNotifierHash() => r'da6919e4ceced53e5ec2834640c4612f9432b661';

/// See also [CHSNotifier].
@ProviderFor(CHSNotifier)
final cHSNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      CHSNotifier,
      CompanionHealthScore?
    >.internal(
      CHSNotifier.new,
      name: r'cHSNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cHSNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CHSNotifier = AutoDisposeAsyncNotifier<CompanionHealthScore?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
