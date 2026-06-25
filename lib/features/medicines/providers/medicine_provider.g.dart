// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medicineDaoHash() => r'6e7b54298b514f909771a51f46a291375e0f2f13';

/// See also [medicineDao].
@ProviderFor(medicineDao)
final medicineDaoProvider = AutoDisposeProvider<MedicineDao>.internal(
  medicineDao,
  name: r'medicineDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicineDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicineDaoRef = AutoDisposeProviderRef<MedicineDao>;
String _$medicineListHash() => r'8b9c83db5621a21c3dbfc2708661802f3bd4768e';

/// See also [medicineList].
@ProviderFor(medicineList)
final medicineListProvider = AutoDisposeFutureProvider<List<Medicine>>.internal(
  medicineList,
  name: r'medicineListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicineListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicineListRef = AutoDisposeFutureProviderRef<List<Medicine>>;
String _$activeMedicinesHash() => r'dc4fa99d2bea1ccc054b1344ceff03c2c4a374a7';

/// See also [activeMedicines].
@ProviderFor(activeMedicines)
final activeMedicinesProvider =
    AutoDisposeStreamProvider<List<Medicine>>.internal(
      activeMedicines,
      name: r'activeMedicinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeMedicinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveMedicinesRef = AutoDisposeStreamProviderRef<List<Medicine>>;
String _$inactiveMedicinesHash() => r'97e52914e0035531ef19814cd723bc14b177008e';

/// See also [inactiveMedicines].
@ProviderFor(inactiveMedicines)
final inactiveMedicinesProvider =
    AutoDisposeStreamProvider<List<Medicine>>.internal(
      inactiveMedicines,
      name: r'inactiveMedicinesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inactiveMedicinesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InactiveMedicinesRef = AutoDisposeStreamProviderRef<List<Medicine>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
