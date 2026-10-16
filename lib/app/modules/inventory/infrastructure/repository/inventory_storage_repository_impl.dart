import 'dart:typed_data';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/inventory_storage_repository.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryStorageRepositoryImpl implements InventoryStorageRepository {
  final String _bucketName;
  final SupabaseClient _supabase;

  InventoryStorageRepositoryImpl(this._bucketName,this._supabase);

  static const _maxImageBytes = 5 * 1024 * 1024;
  static const _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  @override
  Future<String> uploadImage(StorageFolder subFolder,String id, Uint8List imageBytes, String fileName) async {
    try {
      // Fase 3: validación real de tipo/peso antes de subir.
      final fileExtension = fileName.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(fileExtension)) {
        throw StorageException('UNSUPPORTED_TYPE');
      }
      if (imageBytes.lengthInBytes > _maxImageBytes) {
        throw StorageException('FILE_TOO_LARGE');
      }
      final uniqueFileName = '${subFolder.name}/${id}.$fileExtension';

      // Subir archivo a Supabase Storage
      await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            uniqueFileName,
            imageBytes,
            fileOptions: FileOptions(
              contentType: _getMimeType(fileExtension),
              upsert: true,
            ),
          );

      return uniqueFileName;
    } on StorageException {
      rethrow;
    } catch (e) {
      // Fase 3: detalle solo en log, código genérico a UI.
      logging.e('uploadImage failed: $e');
      throw StorageException('UPLOAD_FAILED');
    }
  }

  @override
  Future<String> getImageUrl(String fileName) async {
    try {
      final url = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(fileName);
      
      return url;
    } catch (e) {
      logging.e('getImageUrl failed: $e');
      throw StorageException('LOAD_FAILED');
    }
  }

  @override
  Future<bool> deleteImage(String fileName) async {
    try {
      await _supabase.storage
          .from(_bucketName)
          .remove([fileName]);

      return true;
    } catch (e) {
      logging.e('deleteImage failed: $e');
      throw StorageException('DELETE_FAILED');
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);
  
  @override
  String toString() => 'StorageException: $message';
}

enum StorageFolder {
  productImages,
  categoryImages,
  brandImages,
}