import 'dart:typed_data';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart';

abstract class InventoryStorageRepository {
  Future<String> uploadImage(StorageFolder subFolder, String id, Uint8List imageBytes, String fileName);
  Future<String> getImageUrl(String fileName);
  Future<bool> deleteImage(String fileName);
}
