import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/widgets/inventory_reusable_widgets.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;

  final TextEditingController _brandCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();
  final TextEditingController _brandCategoryIdCtrl = TextEditingController();
  String _selectedCategoryId = '';
  Future<List<Map<String, dynamic>>>? _brandsFuture;
  bool _isLoadingAssociationId = false;

  late bool _isActive;
  bool _isLoading = false;

  Uint8List? _imageBytes;
  String? _imageFileName;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    // Inicializar controladores
    _nameCtrl = TextEditingController(text: widget.product.name);
    _descriptionCtrl = TextEditingController(text: widget.product.description ?? '');
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
    _stockCtrl = TextEditingController(text: widget.product.stockQuantity.toString());
    _isActive = widget.product.isActive;

    // Obtener categoría y marca preseleccionadas
    final categoryAndBrand = await _getCategoryAndBrandIds();
    setState(() {
      _selectedCategoryId = categoryAndBrand['category_id'] ?? '';
      _categoryCtrl.text = categoryAndBrand['category_name'] ?? '';
      _brandCtrl.text = categoryAndBrand['brand_id'] ?? '';
      _brandCategoryIdCtrl.text = widget.product.brandCategoryId;
    });

    // Cargar marcas relacionadas con la categoría
    _updateBrandsList();
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(inventoryProductRepositoryProvider);
      final storageRepo = ref.read(inventoryStorageRepositoryProvider);

      String? imageUrl;
      if (_imageBytes != null && _imageFileName != null) {
        final imageName = await storageRepo.uploadImage(
          StorageFolder.productImages,
          widget.product.code,
          _imageBytes!,
          _imageFileName!,
        );
        imageUrl = await storageRepo.getImageUrl(imageName);
      }

      final updatedData = {
        if (_nameCtrl.text.trim() != widget.product.name)
          'name': _nameCtrl.text.trim(),
        if (_descriptionCtrl.text.trim() != widget.product.description)
          'description': _descriptionCtrl.text.trim(),
        if (double.tryParse(_priceCtrl.text.trim()) != widget.product.price)
          'price': double.tryParse(_priceCtrl.text.trim()),
        if (int.tryParse(_stockCtrl.text.trim()) != widget.product.stockQuantity)
          'stock_quantity': int.tryParse(_stockCtrl.text.trim()),
        'is_active': _isActive,
        if (imageUrl != null) 'image_url': imageUrl,
        if (_brandCategoryIdCtrl.text.isNotEmpty && 
            _brandCategoryIdCtrl.text != widget.product.brandCategoryId)
          'brand_category_id': _brandCategoryIdCtrl.text,
      };

      await repo.updateProduct(widget.product.code, updatedData);

      if (mounted) {
        Navigator.of(
          context,
        ).pop(true); // Retornar true para indicar que se guardó
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.edit, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Editar Producto',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Imagen
                      _buildImageSection(),
                      const SizedBox(height: 16),

                      // Código (solo lectura)
                      TextFormField(
                        initialValue: widget.product.code,
                        decoration: const InputDecoration(
                          labelText: 'Código',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.qr_code),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),

                      // Nombre
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.label),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      TextFormField(
                        controller: _descriptionCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Precio y Stock
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Precio *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'El precio es obligatorio';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Precio inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _stockCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Stock *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.inventory),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'El stock es obligatorio';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Stock inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dropdown Categoría
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),
                      // Contenedor de información
                      _buildBrandDropdown(),
                      const SizedBox(height: 16),

                      // Estado activo
                      SwitchListTile(
                        title: const Text('Producto activo'),
                        subtitle: Text(
                          _isActive
                              ? 'Visible para los clientes'
                              : 'Oculto para los clientes',
                        ),
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProduct,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Container(
        height: 160,
        width: // ancho segun el tamaño del dialog
        MediaQuery.of(context).size.width * 0.9 > 500
            ? 400
            : MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : (widget.product.imageUrl != null &&
                              widget.product.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                            )
                          : _buildImagePlaceholder()),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          'Agregar imagen',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      await InventoryReusableWidgets.pickImage(
        imagePicker: _imagePicker,
        context: context,
        onImagePicked: (bytes, fileName) {
          setState(() {
            _imageBytes = bytes;
            _imageFileName = fileName;
          });
        },
        onError: (error) {
          _showErrorSnackBar('Error al seleccionar imagen: $error');
        },
      );
    } catch (e) {
      _showErrorSnackBar('Error al procesar imagen: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _getCategoryAndBrandIds() async {
    // Extraer los IDs de categoría y marca del producto
    final brandProvider = ref.read(inventoryBrandCategoryRepositoryProvider);
    try {
      final response = await brandProvider
          .getBrandNameAndCategoryNameFromAssociationId(
            widget.product.brandCategoryId,
          );
      logging.i(
        'Categoría y marca obtenidas para asociación ${widget.product.brandCategoryId}: $response'
      );
      return response.isNotEmpty ? response.first : {};
    } catch (e) {
      _showErrorSnackBar('Error al obtener categoría y marca: $e');
      return {};
    }
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
              SnackBar(content: Text('Error al cargar categorías: $error')),
            );
          }
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingContainer();
        }
        if (snapshot.hasError) {
          return _buildInfoContainer('Error al cargar categorías', Colors.red);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildInfoContainer('No hay categorías disponibles', Colors.orange);
        }

        final categories = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
          decoration: const InputDecoration(
            labelText: 'Categoría del Producto',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
          isExpanded: true, // Evitar overflow
          items: categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat['id'],
              child: Text(
                cat['name'],
                overflow: TextOverflow.ellipsis,
              ),
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
        );
      },
    );
  }

  // Método específico para el dropdown de marcas
  Widget _buildBrandDropdown() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _brandsFuture,
      builder: (context, snapshot) {
        if (_selectedCategoryId.isEmpty) {
          return _buildInfoContainer('Primero seleccione una categoría', Colors.grey);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingContainer();
        }

        if (snapshot.hasError) {
          return _buildInfoContainer('Error al cargar marcas', Colors.red);
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
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          isExpanded: true, // Evitar overflow
          items: brands.map((brand) {
            return DropdownMenuItem<String>(
              value: brand['id'],
              child: Text(
                brand['name'],
                overflow: TextOverflow.ellipsis,
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
        );
      },
    );
  }

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
}
