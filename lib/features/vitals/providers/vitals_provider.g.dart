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
String _$recentVitalsHash() => r'1d3200276d8324195549665449d82d062ad49906';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recentVitals].
@ProviderFor(recentVitals)
const recentVitalsProvider = RecentVitalsFamily();

/// See also [recentVitals].
class RecentVitalsFamily extends Family<AsyncValue<List<VitalsEntry>>> {
  /// See also [recentVitals].
  const RecentVitalsFamily();

  /// See also [recentVitals].
  RecentVitalsProvider call(int days) {
    return RecentVitalsProvider(days);
  }

  @override
  RecentVitalsProvider getProviderOverride(
    covariant RecentVitalsProvider provider,
  ) {
    return call(provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentVitalsProvider';
}

/// See also [recentVitals].
class RecentVitalsProvider
    extends AutoDisposeStreamProvider<List<VitalsEntry>> {
  /// See also [recentVitals].
  RecentVitalsProvider(int days)
    : this._internal(
        (ref) => recentVitals(ref as RecentVitalsRef, days),
        from: recentVitalsProvider,
        name: r'recentVitalsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recentVitalsHash,
        dependencies: RecentVitalsFamily._dependencies,
        allTransitiveDependencies:
            RecentVitalsFamily._allTransitiveDependencies,
        days: days,
      );

  RecentVitalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    Stream<List<VitalsEntry>> Function(RecentVitalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentVitalsProvider._internal(
        (ref) => create(ref as RecentVitalsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<VitalsEntry>> createElement() {
    return _RecentVitalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentVitalsProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentVitalsRef on AutoDisposeStreamProviderRef<List<VitalsEntry>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _RecentVitalsProviderElement
    extends AutoDisposeStreamProviderElement<List<VitalsEntry>>
    with RecentVitalsRef {
  _RecentVitalsProviderElement(super.provider);

  @override
  int get days => (origin as RecentVitalsProvider).days;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
