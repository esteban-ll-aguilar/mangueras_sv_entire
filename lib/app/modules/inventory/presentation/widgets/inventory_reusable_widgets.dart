import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';

class InventoryReusableWidgets {
  // Seleccionar imagen desde la galería
  static Future<void> pickImage({
    required ImagePicker imagePicker,
    required BuildContext context,
    required Function(Uint8List, String) onImagePicked,
    required Function(String) onError,
  }) async {
    try {
      final XFile? file = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      onImagePicked(bytes, file.name);
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<List<Map<String, dynamic>>> getBrandsByCategoryDropdown({
    required WidgetRef ref,
    required BuildContext context,
    required String categoryId,
    required Function(String) onError,
  }) async {
    final brandRepo = ref.read(inventoryBrandCategoryRepositoryProvider);
    final brands = await brandRepo.getAllBrandsDropdownByCategoryId(categoryId);

    if (brands.isEmpty) {
      onError('No hay marcas disponibles');
      return [];
    }
    return brands;
  }

  static Future<List<Map<String, dynamic>>> getAllBrandsDropdown({
    required WidgetRef ref,
    required BuildContext context,
    required String categoryId,
    required Function(String) onError,
  }) async {
    final brandRepo = ref.read(inventoryBrandCategoryRepositoryProvider);
    final brands = await brandRepo.getAllBrandsDropdown();

    if (brands.isEmpty) {
      onError('No hay marcas disponibles');
      return [];
    }
    return brands;
  }

  static Future<List<Map<String, dynamic>>> getCategoriesDropdown({
    required WidgetRef ref,
    required BuildContext context,
    required Function(String) onError,
  }) async {
    final categoryRepo = ref.read(inventoryBrandCategoryRepositoryProvider);
    final categories = await categoryRepo.getCategoriesDropdown();

    if (categories.isEmpty) {
      onError('No hay categorías disponibles');
      return [];
    }
    return categories;
  }

  static Future<List<Map<String, dynamic>>> getBrandsDropdown({
    required WidgetRef ref,
    required BuildContext context,
    required Function(String) onError,
  }) async {
    try {
      final repo = ref.read(inventoryBrandCategoryRepositoryProvider);
      final brands = await repo.getAllBrands();
      
      return brands.map((brand) => {
        'id': brand.id,
        'name': brand.name,
      }).toList();
    } catch (e) {
      onError('Error al cargar marcas: $e');
      return [];
    }
  }
}

