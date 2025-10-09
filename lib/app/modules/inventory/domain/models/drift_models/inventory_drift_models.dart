import 'package:drift/drift.dart';

@DataClassName('brand_category_drift_model')
class BrandCategoryDriftModel extends Table{
  TextColumn get id => text()();
  TextColumn get brandId => text()();
  TextColumn get categoryId => text()();

  // Primary key
  @override
  Set<Column> get primaryKey => {id};

  //Unique constraint
  @override
  List<Set<Column>> get uniqueKeys => [
    {brandId, categoryId}
  ];


  // @override
  // List<String> get customConstraints => [
  //   'UNIQUE(brandId, categoryId)',
  //   'CREATE INDEX IF NOT EXISTS idx_brand_category_drift_model_brand_id ON brand_category_drift_model(brandId)',
  //   'CREATE INDEX IF NOT EXISTS idx_brand_category_drift_model_category_id ON brand_category_drift_model(categoryId)'
  // ];
  
}


@DataClassName('brand_drift_model')
class BrandDriftModel extends Table{
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  // @override
  // List<String> get customConstraints => [
  //   'CREATE INDEX IF NOT EXISTS idx_brand_drift_model_name ON brand_drift_model(name)',
  // ];
}


@DataClassName('category_drift_model')
class CategoryDriftModel extends Table{
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get isMainCategory => text().withDefault(Constant('false'))();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  // @override
  // List<String> get customConstraints => [
  //   'CREATE INDEX IF NOT EXISTS idx_category_drift_model_name ON category_drift_model(name)',
  //   'CREATE INDEX IF NOT EXISTS idx_category_drift_model_is_main ON category_drift_model(isMainCategory)',
  // ];
}



@DataClassName('product_drift_model')
class ProductDriftModel extends Table{
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get brandCategoryId => text()();
  RealColumn get price => real()();
  IntColumn get shopQuantity => integer()();
  BoolColumn get isActive => boolean()();


  @override
  Set<Column> get primaryKey => {code};

  // @override
  // List<String> get customConstraints => [
  //   'CREATE INDEX IF NOT EXISTS idx_product_drift_model_name ON product_drift_model(name)',
  //   'CREATE INDEX IF NOT EXISTS idx_product_drift_model_brand_category ON product_drift_model(brandCategoryId)',
  //   'CREATE INDEX IF NOT EXISTS idx_product_drift_model_is_active ON product_drift_model(isActive)',
  // ];
}