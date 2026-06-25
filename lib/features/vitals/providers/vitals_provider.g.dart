// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vitalsDaoHash() => r'01f0587e22fa8b7c27f09bb0abcfad3a9b8921a1';

/// See also [vitalsDao].
@ProviderFor(vitalsDao)
final vitalsDaoProvider = AutoDisposeProvider<VitalsDao>.internal(
  vitalsDao,
  name: r'vitalsDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vitalsDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VitalsDaoRef = AutoDisposeProviderRef<VitalsDao>;
String _$todaysVitalsHash() => r'1ecabd5e40649f01ae0f129b29aba3aa1f5e65c4';

/// See also [todaysVitals].
@ProviderFor(todaysVitals)
final todaysVitalsProvider = AutoDisposeFutureProvider<VitalsEntry?>.internal(
  todaysVitals,
  name: r'todaysVitalsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todaysVitalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodaysVitalsRef = AutoDisposeFutureProviderRef<VitalsEntry?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
