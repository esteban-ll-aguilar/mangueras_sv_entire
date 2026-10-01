import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/widgets/inventory_reusable_widgets.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:mangueras_sv_entire/core/routes/app_router.dart';

class CreateCategoriesFormPage extends ConsumerStatefulWidget {
  const CreateCategoriesFormPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateCategoriesFormPage> createState() =>
      _CreateCategoriesFormPageState();
}

class _CreateCategoriesFormPageState
    extends ConsumerState<CreateCategoriesFormPage> {
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
      final categoryRepo = ref.read(inventoryBrandCategoryRepositoryProvider);

      final created = await categoryRepo.createCategory(
        CategoryModel(
          id: '',
          name: _nameCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
        ),
      );

      if (created == null) {
        throw Exception(
            'No se pudo crear la categoría, revisa que no exista ya');
      }

      String? uploadedFileName;
      String? publicUrl;

      if (_imageBytes != null && _imageFileName != null) {
        uploadedFileName = await storageRepo.uploadImage(
          StorageFolder.categoryImages,
          created.id,
          _imageBytes!,
          _imageFileName!,
        );

        publicUrl = await storageRepo.getImageUrl(uploadedFileName);
        logging.i('Imagen subida: ${created.id} - $publicUrl');
        await categoryRepo.updateCategory(created.id, {'image_url': publicUrl});
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Categoría creada correctamente',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
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
          SnackBar(
            content: Text(
              'Error al guardar: $e',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AuthReusableWidgets.backButton(
            context,
            routeName: AppRouteNames.home.name,
          ),
        ),
        title: Text(
          'Añadir Categoría',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isWeb ? 32 : 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 600 : double.infinity,
            ),
            child: Container(
              padding: EdgeInsets.all(isWeb ? 32 : 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Información de la Categoría',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete los campos para crear una nueva categoría',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo Nombre
                    Text(
                      'Nombre *',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      style: GoogleFonts.inter(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Ingrese el nombre de la categoría',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'El nombre es obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Campo Descripción
                    Text(
                      'Descripción',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionCtrl,
                      style: GoogleFonts.inter(fontSize: 15),
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Ingrese una descripción (opcional)',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sección de Imagen
                    Text(
                      'Imagen',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Vista previa de la imagen
                    if (_imageBytes != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                child: Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _imageFileName ?? 'Imagen seleccionada',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Botones de imagen
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
                                        'Error: $error',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      backgroundColor: Colors.red.shade600,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(
                              Icons.photo_library_outlined,
                              size: 20,
                              color: Colors.black87,
                            ),
                            label: Text(
                              'Seleccionar',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        if (_imageBytes != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _imageBytes = null;
                                  _imageFileName = null;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side:
                                    BorderSide(color: Colors.red.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.red.shade700,
                              ),
                              label: Text(
                                'Eliminar',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Botón Guardar
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          disabledBackgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Guardar Categoría',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}