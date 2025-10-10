import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/widgets/inventory_reusable_widgets.dart';

class EditCategoryPage extends ConsumerStatefulWidget {
  final CategoryModel category;

  const EditCategoryPage({super.key, required this.category});

  @override
  ConsumerState<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends ConsumerState<EditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  List<Map<String, dynamic>> _allBrands = [];
  List<Map<String, dynamic>> _selectedBrands = [];

  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _isLoading = false;
  bool _isBrandsLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.category.name;
    _descriptionCtrl.text = widget.category.description ?? '';
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isBrandsLoading = true);
    await Future.wait([_loadAllBrands(), _loadSelectedBrands()]);
    setState(() => _isBrandsLoading = false);
  }

  Future<void> _loadAllBrands() async {
    try {
      final brandRepo = ref.read(inventoryBrandCategoryRepositoryProvider);
      final brands = await brandRepo.getAllBrandsDropdown();
      setState(() {
        _allBrands = brands;
      });
    } catch (e) {
      _showErrorSnackBar('Error al cargar marcas: $e');
    }
  }

  Future<void> _loadSelectedBrands() async {
    try {
      final brandRepo = ref.read(inventoryBrandCategoryRepositoryProvider);
      final selectedBrands = await brandRepo.getAllBrandsDropdownByCategoryId(
        widget.category.id,
      );
      setState(() {
        _selectedBrands = selectedBrands;
      });
    } catch (e) {
      _showErrorSnackBar('Error al cargar marcas asociadas: $e');
    }
  }

  Future<void> _updateBrandAssociation(String brandId, bool isSelected) async {
    try {
      final brandRepo = ref.read(inventoryBrandCategoryRepositoryProvider);

      if (isSelected) {
        // Agregar asociación
        await brandRepo.associateBrandWithCategory(brandId, widget.category.id);
      } else {
        // Eliminar asociación
        await brandRepo.removeAssociationBrandWithCategory(
          brandId,
          widget.category.id,
        );
      }

      // Recargar las marcas seleccionadas para mantener sincronización
      await _loadSelectedBrands();
    } catch (e) {
      _showErrorSnackBar('Error al actualizar asociación: $e');
      // Revertir el estado local en caso de error
      await _loadSelectedBrands();
    }
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final storageRepo = ref.read(inventoryStorageRepositoryProvider);
    final categoryRepo = ref.read(inventoryBrandCategoryRepositoryProvider);

    setState(() => _isLoading = true);

    try {
      String? imageUrl;
      if (_imageBytes != null && _imageFileName != null) {
        final imageName = await storageRepo.uploadImage(
          StorageFolder.categoryImages,
          widget.category.id,
          _imageBytes!,
          _imageFileName!,
        );
        imageUrl = await storageRepo.getImageUrl(imageName);
      }

      final Map<String, dynamic> data = {
        if (_nameCtrl.text.trim() != widget.category.name)
          'name': _nameCtrl.text.trim(),
        if (_descriptionCtrl.text.trim() != (widget.category.description ?? ''))
          'description': _descriptionCtrl.text.trim(),
        if (imageUrl != null) 'image_url': imageUrl,
      };

      if (data.isEmpty) {
        _showInfoSnackBar('No hay cambios para guardar');
        return;
      }

      await categoryRepo.updateCategory(widget.category.id, data);

      if (mounted) {
        _showSuccessSnackBar('Categoría actualizada correctamente');
        Navigator.of(context).pop(true); // Retornar true para indicar éxito
      }
    } catch (e) {
      _showErrorSnackBar('Error al actualizar categoría: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showInfoSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar Categoría',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.category.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      _buildImageSection(),
                      const SizedBox(height: 32),

                      // Form Fields
                      _buildFormFields(),
                      const SizedBox(height: 32),

                      // Brands Section
                      _buildBrandsSection(),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Container(
        height: 160,
        width: 160,
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
                    : (widget.category.imageUrl != null &&
                              widget.category.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.category.imageUrl!,
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

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameCtrl,
          decoration: InputDecoration(
            labelText: 'Nombre de la categoría',
            prefixIcon: const Icon(Icons.category_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'El nombre es obligatorio'
              : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _descriptionCtrl,
          decoration: InputDecoration(
            labelText: 'Descripción (opcional)',
            prefixIcon: const Icon(Icons.description_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          maxLines: 4,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }

  Widget _buildBrandsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.branding_watermark_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Marcas Asociadas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (_isBrandsLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (_selectedBrands.isEmpty && !_isBrandsLoading)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 32,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No hay marcas asociadas',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              )
            else if (!_isBrandsLoading)
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedBrands
                        .map(
                          (brand) => Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: brand['image_url'] != null && brand['image_url'].isNotEmpty
                                  ? NetworkImage(brand['image_url'])
                                  : null,
                              child: (brand['image_url'] == null || brand['image_url'].isEmpty)
                                  ? Text(
                                      brand['name'][0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            label: Text(brand['name']),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () =>
                                _updateBrandAssociation(brand['id'], false),
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.3),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isBrandsLoading ? null : _showBrandsSelectionDialog,
                icon: const Icon(Icons.add),
                label: const Text('Gestionar Marcas'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Guardar'),
          ),
        ),
      ],
    );
  }

  void _showBrandsSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => _BrandsSelectionDialog(
        allBrands: _allBrands,
        selectedBrands: _selectedBrands,
        categoryId: widget.category.id,
        onBrandToggle: _updateBrandAssociation,
        onBrandsUpdated: _loadSelectedBrands,
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }
}

class _BrandsSelectionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> allBrands;
  final List<Map<String, dynamic>> selectedBrands;
  final String categoryId;
  final Function(String brandId, bool isSelected) onBrandToggle;
  final VoidCallback onBrandsUpdated;

  const _BrandsSelectionDialog({
    required this.allBrands,
    required this.selectedBrands,
    required this.categoryId,
    required this.onBrandToggle,
    required this.onBrandsUpdated,
  });

  @override
  State<_BrandsSelectionDialog> createState() => _BrandsSelectionDialogState();
}

class _BrandsSelectionDialogState extends State<_BrandsSelectionDialog> {
  late Set<String> _selectedIds;
  String _searchQuery = '';
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedBrands.map((b) => b['id'] as String).toSet();
  }

  List<Map<String, dynamic>> get _filteredBrands {
    if (_searchQuery.isEmpty) return widget.allBrands;
    return widget.allBrands
        .where(
          (brand) =>
              brand['name'].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.branding_watermark_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Seleccionar Marcas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.onBrandsUpdated();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar marcas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 16),

            // Selected count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_selectedIds.length} marcas seleccionadas',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Brands list
            Expanded(
              child: _filteredBrands.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron marcas',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredBrands.length,
                      itemBuilder: (context, index) {
                        final brand = _filteredBrands[index];
                        final isSelected = _selectedIds.contains(brand['id']);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 1,
                          child: CheckboxListTile(
                            title: Text(
                              brand['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            value: isSelected,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: _isUpdating
                                ? null
                                : (value) async {
                                    setState(() => _isUpdating = true);

                                    await widget.onBrandToggle(
                                      brand['id'],
                                      value ?? false,
                                    );

                                    setState(() {
                                      if (value == true) {
                                        _selectedIds.add(brand['id']);
                                      } else {
                                        _selectedIds.remove(brand['id']);
                                      }
                                      _isUpdating = false;
                                    });
                                  },
                            secondary: CircleAvatar(
                              backgroundImage: NetworkImage(brand['image_url'] ?? ''),
                              backgroundColor: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                              child: (brand['image_url'] == null || brand['image_url'].isEmpty)
                                  ? Text(
                                      brand['name'][0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Actions
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onBrandsUpdated();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Confirmar Selección'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
