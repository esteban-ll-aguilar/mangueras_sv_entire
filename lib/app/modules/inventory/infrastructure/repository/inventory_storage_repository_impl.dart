import 'dart:typed_data';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/inventory_storage_repository.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryStorageRepositoryImpl implements InventoryStorageRepository {
  final String _bucketName;
  final SupabaseClient _supabase;

  InventoryStorageRepositoryImpl(this._bucketName, this._supabase);

  static const _maxImageBytes = 5 * 1024 * 1024;
  static const _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  @override
  Future<String> uploadImage(
    StorageFolder subFolder,
    String id,
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
<<<<<<< HEAD
      // Fase 3: validación real de tipo/peso antes de subir.
      final fileExtension = fileName.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(fileExtension)) {
        throw StorageException('UNSUPPORTED_TYPE');
      }
      if (imageBytes.lengthInBytes > _maxImageBytes) {
        throw StorageException('FILE_TOO_LARGE');
=======
      final fileExtension = fileName.split('.').last.toLowerCase();
      final mimeType = _detectImageMime(fileExtension, imageBytes);
      if (mimeType == null) {
        throw const StorageException(
          'Solo se permiten imágenes JPG, PNG o WEBP válidas.',
        );
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
      }
      final uniqueFileName = '${subFolder.name}/${id}.$fileExtension';

      // Subir archivo a Supabase Storage
      await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            uniqueFileName,
            imageBytes,
            fileOptions: FileOptions(contentType: mimeType, upsert: true),
          );

      return uniqueFileName;
    } on StorageException {
      rethrow;
    } catch (e) {
<<<<<<< HEAD
      // Fase 3: detalle solo en log, código genérico a UI.
      logging.e('uploadImage failed: $e');
      throw StorageException('UPLOAD_FAILED');
=======
      throw const StorageException('No se pudo subir la imagen.');
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    }
  }

  @override
  Future<String> getImageUrl(String fileName) async {
    try {
      final url = await _supabase.storage
          .from(_bucketName)
          .createSignedUrl(fileName, 3600);

      return url;
    } catch (e) {
<<<<<<< HEAD
      logging.e('getImageUrl failed: $e');
      throw StorageException('LOAD_FAILED');
=======
      throw const StorageException('No se pudo obtener la imagen.');
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    }
  }

  @override
  Future<bool> deleteImage(String fileName) async {
    try {
<<<<<<< HEAD
      await _supabase.storage
          .from(_bucketName)
          .remove([fileName]);

      return true;
    } catch (e) {
      logging.e('deleteImage failed: $e');
      throw StorageException('DELETE_FAILED');
=======
      await _supabase.storage.from(_bucketName).remove([fileName]);

      return true;
    } catch (e) {
      throw const StorageException('No se pudo eliminar la imagen.');
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    }
  }

  String? _detectImageMime(String extension, Uint8List bytes) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return bytes.length >= 3 &&
                bytes[0] == 0xFF &&
                bytes[1] == 0xD8 &&
                bytes[2] == 0xFF
            ? 'image/jpeg'
            : null;
      case 'png':
        return bytes.length >= 8 &&
                bytes[0] == 0x89 &&
                bytes[1] == 0x50 &&
                bytes[2] == 0x4E &&
                bytes[3] == 0x47 &&
                bytes[4] == 0x0D &&
                bytes[5] == 0x0A &&
                bytes[6] == 0x1A &&
                bytes[7] == 0x0A
            ? 'image/png'
            : null;
      case 'webp':
        return bytes.length >= 12 &&
                String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
                String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP'
            ? 'image/webp'
            : null;
      default:
        return null;
    }
  }
}

class StorageException implements Exception {
  final String message;
  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

enum StorageFolder { productImages, categoryImages, brandImages }
