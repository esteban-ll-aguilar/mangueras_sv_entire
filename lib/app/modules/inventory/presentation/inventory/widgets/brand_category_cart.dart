import 'package:flutter/material.dart';

/// Widget genérico para mostrar una tarjeta de marca o categoría.
/// Pasa el item y funciones que extraen los campos necesarios.
class BrandCategoryCard<T> extends StatelessWidget {
  final T item;
  final bool isBrand;
  final String Function(T) getName;
  final String? Function(T) getDescription;
  final String? Function(T) getImageUrl;
  final VoidCallback? onTap;

  const BrandCategoryCard({
    required this.item,
    required this.getName,
    required this.getDescription,
    required this.getImageUrl,
    this.isBrand = true,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final name = getName(item);
    final description = getDescription(item);
    final imageUrl = getImageUrl(item);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      child: InkWell(
        onTap: onTap ??
            () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(name),
                  content: Text(description ?? 'Sin descripción'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar')),
                  ],
                ),
              );
            },
        child: Column(
          children: [
            Expanded(
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? SizedBox.expand(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      (progress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stack) =>
                            const Center(child: Icon(Icons.broken_image, size: 48)),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                          child: Icon(Icons.branding_watermark,
                              size: 48, color: Colors.grey)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description ?? '',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}