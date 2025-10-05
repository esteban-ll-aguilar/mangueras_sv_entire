import 'dart:typed_data';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/inventory_storage_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryStorageRepositoryImpl implements InventoryStorageRepository {
  final String _bucketName;
  final SupabaseClient _supabase;

  InventoryStorageRepositoryImpl(this._bucketName,this._supabase);

  @override
  Future<String> uploadImage(StorageFolder subFolder,String id, Uint8List imageBytes, String fileName) async {
    try {
      // Generar nombre único para el archivo
      final fileExtension = fileName.split('.').last;
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
    } catch (e) {
      throw StorageException('Failed to upload profile image: $e');
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
      throw StorageException('Failed to get profile image URL: $e');
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
      throw StorageException('Failed to delete profile image: $e');
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