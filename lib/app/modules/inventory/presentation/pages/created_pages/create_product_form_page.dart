import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/widgets/inventory_reusable_widgets.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:mangueras_sv_entire/core/routes/app_router.dart';

class CreateProductsFormPage extends ConsumerStatefulWidget {
  const CreateProductsFormPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateProductsFormPage> createState() =>
      _CreateProductsFormPageState();
}

class _CreateProductsFormPageState
    extends ConsumerState<CreateProductsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _stockCtrl = TextEditingController();
  final TextEditingController _brandCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();
  final TextEditingController _brandCategoryIdCtrl = TextEditingController();

  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _isLoading = false;

  // Variables para controlar la actualización de las marcas
  String _selectedCategoryId = '';
  Future<List<Map<String, dynamic>>>? _brandsFuture;
  bool _isLoadingAssociationId = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _brandsFuture = Future.value([]); // Inicializar con lista vacía
  }

  void _updateBrandsList() {
    if (_selectedCategoryId.isNotEmpty) {
      setState(() {
        _brandsFuture = InventoryReusableWidgets.getBrandsByCategoryDropdown(
          ref: ref,
          context: context,
          categoryId: _selectedCategoryId,
          onError: (error) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error)));
            }
          },
        );
      });
    } else {
      setState(() {
        _brandsFuture = Future.value([]);
      });
    }
  }

  // Crear método separado para manejar la selección de marca
  Future<void> _handleBrandSelection(String? value) async {
    // Actualizar estado inmediatamente
    setState(() {
      _brandCtrl.text = value ?? '';
      _brandCategoryIdCtrl.clear();
      _isLoadingAssociationId = value != null && value.isNotEmpty;
    });

    // Si no hay valor seleccionado, salir
    if (value == null || value.isEmpty) {
      setState(() => _isLoadingAssociationId = false);
      return;
    }

    try {
      // Obtener ID de asociación
      final associationId = await _getAssociationId();

      if (mounted) {
        setState(() {
          _brandCategoryIdCtrl.text = associationId ?? '';
          _isLoadingAssociationId = false;
        });

        // Mostrar mensaje si no se encontró asociación
        if (associationId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No se encontró asociación entre marca y categoría',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAssociationId = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al obtener asociación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    // Limpiar todos los controladores
    _codeCtrl.clear();
    _nameCtrl.clear();
    _descriptionCtrl.clear();
    _priceCtrl.clear();
    _stockCtrl.clear();
    _brandCtrl.clear();
    _categoryCtrl.clear();
    _brandCategoryIdCtrl.clear();

    // Resetear el estado
    setState(() {
      _imageBytes = null;
      _imageFileName = null;
      _selectedCategoryId = '';
      _brandsFuture = Future.value([]);
      _isLoadingAssociationId = false;
    });
  }

  Future<String?> _getAssociationId() async {
    // Validar que tengamos los datos necesarios
    if (_selectedCategoryId.isEmpty || _brandCtrl.text.trim().isEmpty) {
      logging.w(
        'Faltan datos para obtener asociación: categoría=$_selectedCategoryId, marca=${_brandCtrl.text}',
      );
      return null;
    }

    try {
      final productRepo = ref.read(inventoryBrandCategoryRepositoryProvider);
      final associationId = await productRepo
          .getAssociationIdFromCategoryIdAndBrandId(
            _selectedCategoryId,
            _brandCtrl.text.trim(),
          );

      logging.i(
        'Association ID obtained: $associationId para categoría=$_selectedCategoryId, marca=${_brandCtrl.text}',
      );
      return associationId;
    } catch (e) {
      logging.e('Error obteniendo association ID: $e');
      rethrow; // Re-lanzar para que sea manejado por el método que llama
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final storageRepo = ref.read(inventoryStorageRepositoryProvider);
      final productRepo = ref.read(inventoryProductRepositoryProvider);

      // Crear el producto sin imagen (createProduct devuelve el ProductModel con id asignado)
      final created = await productRepo.createProduct(
        ProductModel(
          code: _codeCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          brandCategoryId: _brandCategoryIdCtrl.text.trim(),
          price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
          stockQuantity: int.tryParse(_stockCtrl.text.trim()) ?? 0,
          isActive: true,
        ),
      );

      if (created == null) {
        throw Exception(
          'No se pudo crear el producto. Revise los datos e intente nuevamente.',
        );
      }

      String? uploadedFileName;
      String? publicUrl;

      if (_imageBytes != null && _imageFileName != null) {
        // Subir imagen y obtener nombre de archivo en storage
        uploadedFileName = await storageRepo.uploadImage(
          StorageFolder.productImages,
          created.code,
          _imageBytes!,
          _imageFileName!,
        );

        // Obtener URL pública y actualizar la categoría
        publicUrl = await storageRepo.getImageUrl(uploadedFileName);
        logging.i('Imagen subida: ${created.code} - $publicUrl');
        await productRepo.updateProduct(created.code, {'image_url': publicUrl});
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto creado correctamente')),
        );
        // Refrescar la pagina actual para que se borre todo el formulario
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
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
          routeName: AppRouteNames.home.name,
        ),
        title: const Text('Añadir Productos'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determinar padding basado en el ancho de pantalla
            final isWideScreen = constraints.maxWidth > 600;
            final horizontalPadding = isWideScreen ? 32.0 : 16.0;
            final maxWidth = isWideScreen ? 600.0 : double.infinity;

            return Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Todos los campos existentes...
                        _buildTextField(
                          controller: _codeCtrl,
                          labelText: 'Código',
                          hintText: 'Ingrese el código del producto',
                          prefixIcon: Icons.confirmation_num,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'El código es obligatorio'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _nameCtrl,
                          labelText: 'Nombre',
                          hintText: 'Ingrese el nombre del producto',
                          prefixIcon: Icons.label,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'El nombre es obligatorio'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _descriptionCtrl,
                          labelText: 'Descripción',
                          hintText: 'Ingrese la descripción del producto',
                          prefixIcon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        // Dropdown de categorías
                        _buildCategoryDropdown(),
                        const SizedBox(height: 12),
                        // Dropdown de marcas (mejorado)
                        _buildBrandDropdown(),
                        const SizedBox(height: 12),
                        // Resto de campos...
                        _buildPriceField(),
                        const SizedBox(height: 12),
                        _buildStockField(),
                        const SizedBox(height: 12),
                        // Sección de imagen
                        _buildImageSection(),
                        const SizedBox(height: 20),
                        // Botón de envío
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/products');
        },
        icon: const Icon(Icons.home),
        label: const Text('Ver Productos'),
      ),
    );
  }

  // Método helper para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        isDense: true,
      ),
      validator: validator,
    );
  }

  // Método específico para el dropdown de marcas
  Widget _buildBrandDropdown() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _brandsFuture,
      builder: (context, snapshot) {
        if (_selectedCategoryId.isEmpty) {
          return _buildInfoContainer(
            'Primero seleccione una categoría',
            Colors.grey,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingContainer();
        }

        if (snapshot.hasError) {
          return _buildInfoContainer('Error: ${snapshot.error}', Colors.red);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildInfoContainer(
            'No hay marcas disponibles para esta categoría',
            Colors.orange,
          );
        }

        final brands = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: _brandCtrl.text.isEmpty ? null : _brandCtrl.text,
          decoration: InputDecoration(
            labelText: 'Marca del Producto',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.branding_watermark),
            suffixIcon: _isLoadingAssociationId
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            isDense: true,
          ),
          hint: const Text(
            'Seleccione la marca del producto',
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          items: brands.map((brand) {
            final brandName = brand['name'] as String;
            return DropdownMenuItem<String>(
              value: brand['id'],
              child: Tooltip(
                message: brandName,
                child: Text(
                  brandName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            );
          }).toList(),
          onChanged: _handleBrandSelection,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Debe seleccionar una marca';
            }
            return null;
          },
          menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
        );
      },
    );
  }

  // Método helper para contenedores informativos
  Widget _buildInfoContainer(String message, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(message, style: TextStyle(color: color)),
    );
  }

  // Método helper para contenedor de carga
  Widget _buildLoadingContainer() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  // Método para el dropdown de categorías
  Widget _buildCategoryDropdown() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: InventoryReusableWidgets.getCategoriesDropdown(
        ref: ref,
        context: context,
        onError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No hay categorías disponibles')),
            );
          }
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay categorías disponibles');
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final categories = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
          decoration: const InputDecoration(
            labelText: 'Categoría del Producto',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          hint: const Text('Seleccione una categoría'),
          items: categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat['id'],
              child: Text(cat['name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value ?? '';
              _categoryCtrl.text = value ?? '';
              _brandCtrl.clear(); // Limpiar marca seleccionada
              _brandCategoryIdCtrl.clear(); // Limpiar ID de marca-categoría
            });

            // Actualizar lista de marcas
            _updateBrandsList();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Debe seleccionar una categoría';
            }
            return null;
          },
          menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
        );
      },
    );
  }

  // Método para el campo de precio
  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceCtrl,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        labelText: 'Precio del Producto',
        hintText: 'Ingrese el precio del producto',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
    );
  }

  // Método para el campo de stock
  Widget _buildStockField() {
    return TextFormField(
      controller: _stockCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Cantidad en Stock',
        hintText: 'Ingrese la cantidad en stock del producto',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory_2),
      ),
    );
  }

  // Método para la sección de imagen
  Widget _buildImageSection() {
    return Column(
      children: [
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
                          content: Text('Error al seleccionar imagen: $error'),
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
      ],
    );
  }

  // Método para el botón de envío
  Widget _buildSubmitButton() {
    return SizedBox(
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
    );
  }
}
