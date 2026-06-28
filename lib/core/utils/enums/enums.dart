enum supabaseTablesNames {
  brandTable('brand'),
  categoryTable('category'),
  brandCategoryTable('brand_category'),
  productTable('product');

  const supabaseTablesNames(this.value);
  final String value;
}


