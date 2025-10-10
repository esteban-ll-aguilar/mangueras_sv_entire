// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_local_database.dart';

// ignore_for_file: type=lint
class $CartItemDriftModelTable extends CartItemDriftModel
    with TableInfo<$CartItemDriftModelTable, cart_item_drift_model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productCodeMeta = const VerificationMeta(
    'productCode',
  );
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
    'product_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productImageUrlMeta = const VerificationMeta(
    'productImageUrl',
  );
  @override
  late final GeneratedColumn<String> productImageUrl = GeneratedColumn<String>(
    'product_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productPriceMeta = const VerificationMeta(
    'productPrice',
  );
  @override
  late final GeneratedColumn<double> productPrice = GeneratedColumn<double>(
    'product_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandNameMeta = const VerificationMeta(
    'brandName',
  );
  @override
  late final GeneratedColumn<String> brandName = GeneratedColumn<String>(
    'brand_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productCode,
    productName,
    productImageUrl,
    productPrice,
    quantity,
    brandName,
    categoryName,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_item_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<cart_item_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_code')) {
      context.handle(
        _productCodeMeta,
        productCode.isAcceptableOrUnknown(
          data['product_code']!,
          _productCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productCodeMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('product_image_url')) {
      context.handle(
        _productImageUrlMeta,
        productImageUrl.isAcceptableOrUnknown(
          data['product_image_url']!,
          _productImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('product_price')) {
      context.handle(
        _productPriceMeta,
        productPrice.isAcceptableOrUnknown(
          data['product_price']!,
          _productPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('brand_name')) {
      context.handle(
        _brandNameMeta,
        brandName.isAcceptableOrUnknown(data['brand_name']!, _brandNameMeta),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productCode};
  @override
  cart_item_drift_model map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return cart_item_drift_model(
      productCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_code'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      productImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_image_url'],
      ),
      productPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}product_price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      brandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_name'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $CartItemDriftModelTable createAlias(String alias) {
    return $CartItemDriftModelTable(attachedDatabase, alias);
  }
}

class cart_item_drift_model extends DataClass
    implements Insertable<cart_item_drift_model> {
  final String productCode;
  final String productName;
  final String? productImageUrl;
  final double productPrice;
  final int quantity;
  final String? brandName;
  final String? categoryName;
  final DateTime addedAt;
  const cart_item_drift_model({
    required this.productCode,
    required this.productName,
    this.productImageUrl,
    required this.productPrice,
    required this.quantity,
    this.brandName,
    this.categoryName,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_code'] = Variable<String>(productCode);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || productImageUrl != null) {
      map['product_image_url'] = Variable<String>(productImageUrl);
    }
    map['product_price'] = Variable<double>(productPrice);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || brandName != null) {
      map['brand_name'] = Variable<String>(brandName);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  CartItemDriftModelCompanion toCompanion(bool nullToAbsent) {
    return CartItemDriftModelCompanion(
      productCode: Value(productCode),
      productName: Value(productName),
      productImageUrl: productImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(productImageUrl),
      productPrice: Value(productPrice),
      quantity: Value(quantity),
      brandName: brandName == null && nullToAbsent
          ? const Value.absent()
          : Value(brandName),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      addedAt: Value(addedAt),
    );
  }

  factory cart_item_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return cart_item_drift_model(
      productCode: serializer.fromJson<String>(json['productCode']),
      productName: serializer.fromJson<String>(json['productName']),
      productImageUrl: serializer.fromJson<String?>(json['productImageUrl']),
      productPrice: serializer.fromJson<double>(json['productPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      brandName: serializer.fromJson<String?>(json['brandName']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productCode': serializer.toJson<String>(productCode),
      'productName': serializer.toJson<String>(productName),
      'productImageUrl': serializer.toJson<String?>(productImageUrl),
      'productPrice': serializer.toJson<double>(productPrice),
      'quantity': serializer.toJson<int>(quantity),
      'brandName': serializer.toJson<String?>(brandName),
      'categoryName': serializer.toJson<String?>(categoryName),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  cart_item_drift_model copyWith({
    String? productCode,
    String? productName,
    Value<String?> productImageUrl = const Value.absent(),
    double? productPrice,
    int? quantity,
    Value<String?> brandName = const Value.absent(),
    Value<String?> categoryName = const Value.absent(),
    DateTime? addedAt,
  }) => cart_item_drift_model(
    productCode: productCode ?? this.productCode,
    productName: productName ?? this.productName,
    productImageUrl: productImageUrl.present
        ? productImageUrl.value
        : this.productImageUrl,
    productPrice: productPrice ?? this.productPrice,
    quantity: quantity ?? this.quantity,
    brandName: brandName.present ? brandName.value : this.brandName,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    addedAt: addedAt ?? this.addedAt,
  );
  cart_item_drift_model copyWithCompanion(CartItemDriftModelCompanion data) {
    return cart_item_drift_model(
      productCode: data.productCode.present
          ? data.productCode.value
          : this.productCode,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      productImageUrl: data.productImageUrl.present
          ? data.productImageUrl.value
          : this.productImageUrl,
      productPrice: data.productPrice.present
          ? data.productPrice.value
          : this.productPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      brandName: data.brandName.present ? data.brandName.value : this.brandName,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('cart_item_drift_model(')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('productImageUrl: $productImageUrl, ')
          ..write('productPrice: $productPrice, ')
          ..write('quantity: $quantity, ')
          ..write('brandName: $brandName, ')
          ..write('categoryName: $categoryName, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productCode,
    productName,
    productImageUrl,
    productPrice,
    quantity,
    brandName,
    categoryName,
    addedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is cart_item_drift_model &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.productImageUrl == this.productImageUrl &&
          other.productPrice == this.productPrice &&
          other.quantity == this.quantity &&
          other.brandName == this.brandName &&
          other.categoryName == this.categoryName &&
          other.addedAt == this.addedAt);
}

class CartItemDriftModelCompanion
    extends UpdateCompanion<cart_item_drift_model> {
  final Value<String> productCode;
  final Value<String> productName;
  final Value<String?> productImageUrl;
  final Value<double> productPrice;
  final Value<int> quantity;
  final Value<String?> brandName;
  final Value<String?> categoryName;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const CartItemDriftModelCompanion({
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.productImageUrl = const Value.absent(),
    this.productPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.brandName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartItemDriftModelCompanion.insert({
    required String productCode,
    required String productName,
    this.productImageUrl = const Value.absent(),
    required double productPrice,
    required int quantity,
    this.brandName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : productCode = Value(productCode),
       productName = Value(productName),
       productPrice = Value(productPrice),
       quantity = Value(quantity);
  static Insertable<cart_item_drift_model> custom({
    Expression<String>? productCode,
    Expression<String>? productName,
    Expression<String>? productImageUrl,
    Expression<double>? productPrice,
    Expression<int>? quantity,
    Expression<String>? brandName,
    Expression<String>? categoryName,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productCode != null) 'product_code': productCode,
      if (productName != null) 'product_name': productName,
      if (productImageUrl != null) 'product_image_url': productImageUrl,
      if (productPrice != null) 'product_price': productPrice,
      if (quantity != null) 'quantity': quantity,
      if (brandName != null) 'brand_name': brandName,
      if (categoryName != null) 'category_name': categoryName,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartItemDriftModelCompanion copyWith({
    Value<String>? productCode,
    Value<String>? productName,
    Value<String?>? productImageUrl,
    Value<double>? productPrice,
    Value<int>? quantity,
    Value<String?>? brandName,
    Value<String?>? categoryName,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return CartItemDriftModelCompanion(
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      brandName: brandName ?? this.brandName,
      categoryName: categoryName ?? this.categoryName,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (productImageUrl.present) {
      map['product_image_url'] = Variable<String>(productImageUrl.value);
    }
    if (productPrice.present) {
      map['product_price'] = Variable<double>(productPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (brandName.present) {
      map['brand_name'] = Variable<String>(brandName.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemDriftModelCompanion(')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('productImageUrl: $productImageUrl, ')
          ..write('productPrice: $productPrice, ')
          ..write('quantity: $quantity, ')
          ..write('brandName: $brandName, ')
          ..write('categoryName: $categoryName, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppLocalDatabase extends GeneratedDatabase {
  _$AppLocalDatabase(QueryExecutor e) : super(e);
  $AppLocalDatabaseManager get managers => $AppLocalDatabaseManager(this);
  late final $CartItemDriftModelTable cartItemDriftModel =
      $CartItemDriftModelTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cartItemDriftModel];
}

typedef $$CartItemDriftModelTableCreateCompanionBuilder =
    CartItemDriftModelCompanion Function({
      required String productCode,
      required String productName,
      Value<String?> productImageUrl,
      required double productPrice,
      required int quantity,
      Value<String?> brandName,
      Value<String?> categoryName,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });
typedef $$CartItemDriftModelTableUpdateCompanionBuilder =
    CartItemDriftModelCompanion Function({
      Value<String> productCode,
      Value<String> productName,
      Value<String?> productImageUrl,
      Value<double> productPrice,
      Value<int> quantity,
      Value<String?> brandName,
      Value<String?> categoryName,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

class $$CartItemDriftModelTableFilterComposer
    extends Composer<_$AppLocalDatabase, $CartItemDriftModelTable> {
  $$CartItemDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productImageUrl => $composableBuilder(
    column: $table.productImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get productPrice => $composableBuilder(
    column: $table.productPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CartItemDriftModelTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $CartItemDriftModelTable> {
  $$CartItemDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productImageUrl => $composableBuilder(
    column: $table.productImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get productPrice => $composableBuilder(
    column: $table.productPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartItemDriftModelTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $CartItemDriftModelTable> {
  $$CartItemDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productImageUrl => $composableBuilder(
    column: $table.productImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<double> get productPrice => $composableBuilder(
    column: $table.productPrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get brandName =>
      $composableBuilder(column: $table.brandName, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$CartItemDriftModelTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $CartItemDriftModelTable,
          cart_item_drift_model,
          $$CartItemDriftModelTableFilterComposer,
          $$CartItemDriftModelTableOrderingComposer,
          $$CartItemDriftModelTableAnnotationComposer,
          $$CartItemDriftModelTableCreateCompanionBuilder,
          $$CartItemDriftModelTableUpdateCompanionBuilder,
          (
            cart_item_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $CartItemDriftModelTable,
              cart_item_drift_model
            >,
          ),
          cart_item_drift_model,
          PrefetchHooks Function()
        > {
  $$CartItemDriftModelTableTableManager(
    _$AppLocalDatabase db,
    $CartItemDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemDriftModelTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> productCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> productImageUrl = const Value.absent(),
                Value<double> productPrice = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> brandName = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartItemDriftModelCompanion(
                productCode: productCode,
                productName: productName,
                productImageUrl: productImageUrl,
                productPrice: productPrice,
                quantity: quantity,
                brandName: brandName,
                categoryName: categoryName,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productCode,
                required String productName,
                Value<String?> productImageUrl = const Value.absent(),
                required double productPrice,
                required int quantity,
                Value<String?> brandName = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartItemDriftModelCompanion.insert(
                productCode: productCode,
                productName: productName,
                productImageUrl: productImageUrl,
                productPrice: productPrice,
                quantity: quantity,
                brandName: brandName,
                categoryName: categoryName,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CartItemDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $CartItemDriftModelTable,
      cart_item_drift_model,
      $$CartItemDriftModelTableFilterComposer,
      $$CartItemDriftModelTableOrderingComposer,
      $$CartItemDriftModelTableAnnotationComposer,
      $$CartItemDriftModelTableCreateCompanionBuilder,
      $$CartItemDriftModelTableUpdateCompanionBuilder,
      (
        cart_item_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $CartItemDriftModelTable,
          cart_item_drift_model
        >,
      ),
      cart_item_drift_model,
      PrefetchHooks Function()
    >;

class $AppLocalDatabaseManager {
  final _$AppLocalDatabase _db;
  $AppLocalDatabaseManager(this._db);
  $$CartItemDriftModelTableTableManager get cartItemDriftModel =>
      $$CartItemDriftModelTableTableManager(_db, _db.cartItemDriftModel);
}
