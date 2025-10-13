import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/widgets/inventory_reusable_widgets.dart';
import 'package:mangueras_sv_entire/core/routes/admin_routes.dart';
import 'package:mangueras_sv_entire/core/routes/common_router.dart';

class CreateBrandsFormPage extends ConsumerStatefulWidget {
  const CreateBrandsFormPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateBrandsFormPage> createState() =>
      _CreateBrandsFormPageState();
}

class _CreateBrandsFormPageState extends ConsumerState<CreateBrandsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final storageRepo = ref.read(inventoryStorageRepositoryProvider);
      final brandRepo = ref.read(inventoryBrandCategoryRepositoryProvider);

      // Crear la marca sin imagen (supongo que createBrand devuelve el BrandModel con id asignado)
      final created = await brandRepo.createBrand(
        BrandModel(
          id: '',
          name: _nameCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
        ),
      );

      if (created == null) {
        throw Exception('No se pudo crear la marca, revisa que no exista ya');
      }

      String? uploadedFileName;
      String? publicUrl;

      if (_imageBytes != null && _imageFileName != null) {
        // Subir imagen y obtener nombre de archivo en storage
        uploadedFileName = await storageRepo.uploadImage(
          StorageFolder.brandImages,
          created.id,
          _imageBytes!,
          _imageFileName!,
        );

        // Obtener URL pública y actualizar la marca
        publicUrl = await storageRepo.getImageUrl(uploadedFileName);
        await brandRepo.updateBrand(created.id, {'image_url': publicUrl});
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marca creada correctamente')),
        );
        // Eliminar field values
        _formKey.currentState!.reset();
        setState(() {
          _imageBytes = null;
          _imageFileName = null;
          _descriptionCtrl.clear();
          _nameCtrl.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AuthReusableWidgets.backButton(
          context,
          routeName: AdminAppRouterNames.home.name,
        ),
        title: const Text('Añadir Marcas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre de la marca',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese la descripción de la marca',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Vista previa de la imagen seleccionada
              if (_imageBytes != null)
                Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 8),
                    Text(_imageFileName ?? ''),
                    const SizedBox(height: 8),
                  ],
                ),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        InventoryReusableWidgets.pickImage(
                          imagePicker: _imagePicker,
                          context: context,
                          onImagePicked: (bytes, fileName) {
                            setState(() {
                              _imageBytes = bytes;
                              _imageFileName = fileName;
                            });
                          },
                          onError: (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error al seleccionar imagen: $error',
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Seleccionar imagen'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _imageBytes = null;
                          _imageFileName = null;
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}