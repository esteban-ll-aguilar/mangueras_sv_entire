// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_local_database_native.dart';

// ignore_for_file: type=lint
class $ProductDriftModelTable extends ProductDriftModel
    with TableInfo<$ProductDriftModelTable, product_drift_model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandCategoryIdMeta = const VerificationMeta(
    'brandCategoryId',
  );
  @override
  late final GeneratedColumn<String> brandCategoryId = GeneratedColumn<String>(
    'brand_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopQuantityMeta = const VerificationMeta(
    'shopQuantity',
  );
  @override
  late final GeneratedColumn<int> shopQuantity = GeneratedColumn<int>(
    'shop_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    code,
    name,
    description,
    imageUrl,
    brandCategoryId,
    price,
    shopQuantity,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<product_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('brand_category_id')) {
      context.handle(
        _brandCategoryIdMeta,
        brandCategoryId.isAcceptableOrUnknown(
          data['brand_category_id']!,
          _brandCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_brandCategoryIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('shop_quantity')) {
      context.handle(
        _shopQuantityMeta,
        shopQuantity.isAcceptableOrUnknown(
          data['shop_quantity']!,
          _shopQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shopQuantityMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  product_drift_model map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return product_drift_model(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      brandCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_category_id'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      shopQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shop_quantity'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ProductDriftModelTable createAlias(String alias) {
    return $ProductDriftModelTable(attachedDatabase, alias);
  }
}

class product_drift_model extends DataClass
    implements Insertable<product_drift_model> {
  final String code;
  final String name;
  final String? description;
  final String? imageUrl;
  final String brandCategoryId;
  final double price;
  final int shopQuantity;
  final bool isActive;
  const product_drift_model({
    required this.code,
    required this.name,
    this.description,
    this.imageUrl,
    required this.brandCategoryId,
    required this.price,
    required this.shopQuantity,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['brand_category_id'] = Variable<String>(brandCategoryId);
    map['price'] = Variable<double>(price);
    map['shop_quantity'] = Variable<int>(shopQuantity);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductDriftModelCompanion toCompanion(bool nullToAbsent) {
    return ProductDriftModelCompanion(
      code: Value(code),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      brandCategoryId: Value(brandCategoryId),
      price: Value(price),
      shopQuantity: Value(shopQuantity),
      isActive: Value(isActive),
    );
  }

  factory product_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return product_drift_model(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      brandCategoryId: serializer.fromJson<String>(json['brandCategoryId']),
      price: serializer.fromJson<double>(json['price']),
      shopQuantity: serializer.fromJson<int>(json['shopQuantity']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'brandCategoryId': serializer.toJson<String>(brandCategoryId),
      'price': serializer.toJson<double>(price),
      'shopQuantity': serializer.toJson<int>(shopQuantity),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  product_drift_model copyWith({
    String? code,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    String? brandCategoryId,
    double? price,
    int? shopQuantity,
    bool? isActive,
  }) => product_drift_model(
    code: code ?? this.code,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    brandCategoryId: brandCategoryId ?? this.brandCategoryId,
    price: price ?? this.price,
    shopQuantity: shopQuantity ?? this.shopQuantity,
    isActive: isActive ?? this.isActive,
  );
  product_drift_model copyWithCompanion(ProductDriftModelCompanion data) {
    return product_drift_model(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      brandCategoryId: data.brandCategoryId.present
          ? data.brandCategoryId.value
          : this.brandCategoryId,
      price: data.price.present ? data.price.value : this.price,
      shopQuantity: data.shopQuantity.present
          ? data.shopQuantity.value
          : this.shopQuantity,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('product_drift_model(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('brandCategoryId: $brandCategoryId, ')
          ..write('price: $price, ')
          ..write('shopQuantity: $shopQuantity, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    code,
    name,
    description,
    imageUrl,
    brandCategoryId,
    price,
    shopQuantity,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is product_drift_model &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.brandCategoryId == this.brandCategoryId &&
          other.price == this.price &&
          other.shopQuantity == this.shopQuantity &&
          other.isActive == this.isActive);
}

class ProductDriftModelCompanion extends UpdateCompanion<product_drift_model> {
  final Value<String> code;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<String> brandCategoryId;
  final Value<double> price;
  final Value<int> shopQuantity;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProductDriftModelCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.brandCategoryId = const Value.absent(),
    this.price = const Value.absent(),
    this.shopQuantity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductDriftModelCompanion.insert({
    required String code,
    required String name,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required String brandCategoryId,
    required double price,
    required int shopQuantity,
    required bool isActive,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       brandCategoryId = Value(brandCategoryId),
       price = Value(price),
       shopQuantity = Value(shopQuantity),
       isActive = Value(isActive);
  static Insertable<product_drift_model> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<String>? brandCategoryId,
    Expression<double>? price,
    Expression<int>? shopQuantity,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (brandCategoryId != null) 'brand_category_id': brandCategoryId,
      if (price != null) 'price': price,
      if (shopQuantity != null) 'shop_quantity': shopQuantity,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductDriftModelCompanion copyWith({
    Value<String>? code,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<String>? brandCategoryId,
    Value<double>? price,
    Value<int>? shopQuantity,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return ProductDriftModelCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      brandCategoryId: brandCategoryId ?? this.brandCategoryId,
      price: price ?? this.price,
      shopQuantity: shopQuantity ?? this.shopQuantity,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (brandCategoryId.present) {
      map['brand_category_id'] = Variable<String>(brandCategoryId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (shopQuantity.present) {
      map['shop_quantity'] = Variable<int>(shopQuantity.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductDriftModelCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('brandCategoryId: $brandCategoryId, ')
          ..write('price: $price, ')
          ..write('shopQuantity: $shopQuantity, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandDriftModelTable extends BrandDriftModel
    with TableInfo<$BrandDriftModelTable, brand_drift_model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, imageUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brand_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<brand_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  brand_drift_model map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return brand_drift_model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $BrandDriftModelTable createAlias(String alias) {
    return $BrandDriftModelTable(attachedDatabase, alias);
  }
}

class brand_drift_model extends DataClass
    implements Insertable<brand_drift_model> {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  const brand_drift_model({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  BrandDriftModelCompanion toCompanion(bool nullToAbsent) {
    return BrandDriftModelCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory brand_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return brand_drift_model(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  brand_drift_model copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
  }) => brand_drift_model(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
  );
  brand_drift_model copyWithCompanion(BrandDriftModelCompanion data) {
    return brand_drift_model(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('brand_drift_model(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is brand_drift_model &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl);
}

class BrandDriftModelCompanion extends UpdateCompanion<brand_drift_model> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const BrandDriftModelCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandDriftModelCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<brand_drift_model> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrandDriftModelCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return BrandDriftModelCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryDriftModelTable extends CategoryDriftModel
    with TableInfo<$CategoryDriftModelTable, category_drift_model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isMainCategoryMeta = const VerificationMeta(
    'isMainCategory',
  );
  @override
  late final GeneratedColumn<String> isMainCategory = GeneratedColumn<String>(
    'is_main_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant('false'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    isMainCategory,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<category_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_main_category')) {
      context.handle(
        _isMainCategoryMeta,
        isMainCategory.isAcceptableOrUnknown(
          data['is_main_category']!,
          _isMainCategoryMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  category_drift_model map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return category_drift_model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isMainCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}is_main_category'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $CategoryDriftModelTable createAlias(String alias) {
    return $CategoryDriftModelTable(attachedDatabase, alias);
  }
}

class category_drift_model extends DataClass
    implements Insertable<category_drift_model> {
  final String id;
  final String name;
  final String? description;
  final String isMainCategory;
  final String? imageUrl;
  const category_drift_model({
    required this.id,
    required this.name,
    this.description,
    required this.isMainCategory,
    this.imageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_main_category'] = Variable<String>(isMainCategory);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  CategoryDriftModelCompanion toCompanion(bool nullToAbsent) {
    return CategoryDriftModelCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isMainCategory: Value(isMainCategory),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory category_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return category_drift_model(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isMainCategory: serializer.fromJson<String>(json['isMainCategory']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isMainCategory': serializer.toJson<String>(isMainCategory),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  category_drift_model copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? isMainCategory,
    Value<String?> imageUrl = const Value.absent(),
  }) => category_drift_model(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isMainCategory: isMainCategory ?? this.isMainCategory,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
  );
  category_drift_model copyWithCompanion(CategoryDriftModelCompanion data) {
    return category_drift_model(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      isMainCategory: data.isMainCategory.present
          ? data.isMainCategory.value
          : this.isMainCategory,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('category_drift_model(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isMainCategory: $isMainCategory, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, isMainCategory, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is category_drift_model &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.isMainCategory == this.isMainCategory &&
          other.imageUrl == this.imageUrl);
}

class CategoryDriftModelCompanion
    extends UpdateCompanion<category_drift_model> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> isMainCategory;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const CategoryDriftModelCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isMainCategory = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryDriftModelCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.isMainCategory = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<category_drift_model> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? isMainCategory,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isMainCategory != null) 'is_main_category': isMainCategory,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryDriftModelCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? isMainCategory,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return CategoryDriftModelCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isMainCategory: isMainCategory ?? this.isMainCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isMainCategory.present) {
      map['is_main_category'] = Variable<String>(isMainCategory.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isMainCategory: $isMainCategory, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandCategoryDriftModelTable extends BrandCategoryDriftModel
    with TableInfo<$BrandCategoryDriftModelTable, brand_category_drift_model> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandCategoryDriftModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, brandId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brand_category_drift_model';
  @override
  VerificationContext validateIntegrity(
    Insertable<brand_category_drift_model> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_brandIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {brandId, categoryId},
  ];
  @override
  brand_category_drift_model map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return brand_category_drift_model(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $BrandCategoryDriftModelTable createAlias(String alias) {
    return $BrandCategoryDriftModelTable(attachedDatabase, alias);
  }
}

class brand_category_drift_model extends DataClass
    implements Insertable<brand_category_drift_model> {
  final String id;
  final String brandId;
  final String categoryId;
  const brand_category_drift_model({
    required this.id,
    required this.brandId,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['brand_id'] = Variable<String>(brandId);
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  BrandCategoryDriftModelCompanion toCompanion(bool nullToAbsent) {
    return BrandCategoryDriftModelCompanion(
      id: Value(id),
      brandId: Value(brandId),
      categoryId: Value(categoryId),
    );
  }

  factory brand_category_drift_model.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return brand_category_drift_model(
      id: serializer.fromJson<String>(json['id']),
      brandId: serializer.fromJson<String>(json['brandId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'brandId': serializer.toJson<String>(brandId),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  brand_category_drift_model copyWith({
    String? id,
    String? brandId,
    String? categoryId,
  }) => brand_category_drift_model(
    id: id ?? this.id,
    brandId: brandId ?? this.brandId,
    categoryId: categoryId ?? this.categoryId,
  );
  brand_category_drift_model copyWithCompanion(
    BrandCategoryDriftModelCompanion data,
  ) {
    return brand_category_drift_model(
      id: data.id.present ? data.id.value : this.id,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('brand_category_drift_model(')
          ..write('id: $id, ')
          ..write('brandId: $brandId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, brandId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is brand_category_drift_model &&
          other.id == this.id &&
          other.brandId == this.brandId &&
          other.categoryId == this.categoryId);
}

class BrandCategoryDriftModelCompanion
    extends UpdateCompanion<brand_category_drift_model> {
  final Value<String> id;
  final Value<String> brandId;
  final Value<String> categoryId;
  final Value<int> rowid;
  const BrandCategoryDriftModelCompanion({
    this.id = const Value.absent(),
    this.brandId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandCategoryDriftModelCompanion.insert({
    required String id,
    required String brandId,
    required String categoryId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       brandId = Value(brandId),
       categoryId = Value(categoryId);
  static Insertable<brand_category_drift_model> custom({
    Expression<String>? id,
    Expression<String>? brandId,
    Expression<String>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brandId != null) 'brand_id': brandId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrandCategoryDriftModelCompanion copyWith({
    Value<String>? id,
    Value<String>? brandId,
    Value<String>? categoryId,
    Value<int>? rowid,
  }) {
    return BrandCategoryDriftModelCompanion(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandCategoryDriftModelCompanion(')
          ..write('id: $id, ')
          ..write('brandId: $brandId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppLocalDatabase extends GeneratedDatabase {
  _$AppLocalDatabase(QueryExecutor e) : super(e);
  $AppLocalDatabaseManager get managers => $AppLocalDatabaseManager(this);
  late final $ProductDriftModelTable productDriftModel =
      $ProductDriftModelTable(this);
  late final $BrandDriftModelTable brandDriftModel = $BrandDriftModelTable(
    this,
  );
  late final $CategoryDriftModelTable categoryDriftModel =
      $CategoryDriftModelTable(this);
  late final $BrandCategoryDriftModelTable brandCategoryDriftModel =
      $BrandCategoryDriftModelTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productDriftModel,
    brandDriftModel,
    categoryDriftModel,
    brandCategoryDriftModel,
  ];
}

typedef $$ProductDriftModelTableCreateCompanionBuilder =
    ProductDriftModelCompanion Function({
      required String code,
      required String name,
      Value<String?> description,
      Value<String?> imageUrl,
      required String brandCategoryId,
      required double price,
      required int shopQuantity,
      required bool isActive,
      Value<int> rowid,
    });
typedef $$ProductDriftModelTableUpdateCompanionBuilder =
    ProductDriftModelCompanion Function({
      Value<String> code,
      Value<String> name,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<String> brandCategoryId,
      Value<double> price,
      Value<int> shopQuantity,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$ProductDriftModelTableFilterComposer
    extends Composer<_$AppLocalDatabase, $ProductDriftModelTable> {
  $$ProductDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandCategoryId => $composableBuilder(
    column: $table.brandCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shopQuantity => $composableBuilder(
    column: $table.shopQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductDriftModelTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $ProductDriftModelTable> {
  $$ProductDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandCategoryId => $composableBuilder(
    column: $table.brandCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shopQuantity => $composableBuilder(
    column: $table.shopQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductDriftModelTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $ProductDriftModelTable> {
  $$ProductDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get brandCategoryId => $composableBuilder(
    column: $table.brandCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get shopQuantity => $composableBuilder(
    column: $table.shopQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ProductDriftModelTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $ProductDriftModelTable,
          product_drift_model,
          $$ProductDriftModelTableFilterComposer,
          $$ProductDriftModelTableOrderingComposer,
          $$ProductDriftModelTableAnnotationComposer,
          $$ProductDriftModelTableCreateCompanionBuilder,
          $$ProductDriftModelTableUpdateCompanionBuilder,
          (
            product_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $ProductDriftModelTable,
              product_drift_model
            >,
          ),
          product_drift_model,
          PrefetchHooks Function()
        > {
  $$ProductDriftModelTableTableManager(
    _$AppLocalDatabase db,
    $ProductDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductDriftModelTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> brandCategoryId = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> shopQuantity = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductDriftModelCompanion(
                code: code,
                name: name,
                description: description,
                imageUrl: imageUrl,
                brandCategoryId: brandCategoryId,
                price: price,
                shopQuantity: shopQuantity,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                required String brandCategoryId,
                required double price,
                required int shopQuantity,
                required bool isActive,
                Value<int> rowid = const Value.absent(),
              }) => ProductDriftModelCompanion.insert(
                code: code,
                name: name,
                description: description,
                imageUrl: imageUrl,
                brandCategoryId: brandCategoryId,
                price: price,
                shopQuantity: shopQuantity,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $ProductDriftModelTable,
      product_drift_model,
      $$ProductDriftModelTableFilterComposer,
      $$ProductDriftModelTableOrderingComposer,
      $$ProductDriftModelTableAnnotationComposer,
      $$ProductDriftModelTableCreateCompanionBuilder,
      $$ProductDriftModelTableUpdateCompanionBuilder,
      (
        product_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $ProductDriftModelTable,
          product_drift_model
        >,
      ),
      product_drift_model,
      PrefetchHooks Function()
    >;
typedef $$BrandDriftModelTableCreateCompanionBuilder =
    BrandDriftModelCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$BrandDriftModelTableUpdateCompanionBuilder =
    BrandDriftModelCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

class $$BrandDriftModelTableFilterComposer
    extends Composer<_$AppLocalDatabase, $BrandDriftModelTable> {
  $$BrandDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrandDriftModelTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $BrandDriftModelTable> {
  $$BrandDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandDriftModelTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $BrandDriftModelTable> {
  $$BrandDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$BrandDriftModelTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $BrandDriftModelTable,
          brand_drift_model,
          $$BrandDriftModelTableFilterComposer,
          $$BrandDriftModelTableOrderingComposer,
          $$BrandDriftModelTableAnnotationComposer,
          $$BrandDriftModelTableCreateCompanionBuilder,
          $$BrandDriftModelTableUpdateCompanionBuilder,
          (
            brand_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $BrandDriftModelTable,
              brand_drift_model
            >,
          ),
          brand_drift_model,
          PrefetchHooks Function()
        > {
  $$BrandDriftModelTableTableManager(
    _$AppLocalDatabase db,
    $BrandDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrandDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrandDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrandDriftModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandDriftModelCompanion(
                id: id,
                name: name,
                description: description,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandDriftModelCompanion.insert(
                id: id,
                name: name,
                description: description,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrandDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $BrandDriftModelTable,
      brand_drift_model,
      $$BrandDriftModelTableFilterComposer,
      $$BrandDriftModelTableOrderingComposer,
      $$BrandDriftModelTableAnnotationComposer,
      $$BrandDriftModelTableCreateCompanionBuilder,
      $$BrandDriftModelTableUpdateCompanionBuilder,
      (
        brand_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $BrandDriftModelTable,
          brand_drift_model
        >,
      ),
      brand_drift_model,
      PrefetchHooks Function()
    >;
typedef $$CategoryDriftModelTableCreateCompanionBuilder =
    CategoryDriftModelCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String> isMainCategory,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$CategoryDriftModelTableUpdateCompanionBuilder =
    CategoryDriftModelCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> isMainCategory,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

class $$CategoryDriftModelTableFilterComposer
    extends Composer<_$AppLocalDatabase, $CategoryDriftModelTable> {
  $$CategoryDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isMainCategory => $composableBuilder(
    column: $table.isMainCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoryDriftModelTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $CategoryDriftModelTable> {
  $$CategoryDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isMainCategory => $composableBuilder(
    column: $table.isMainCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryDriftModelTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $CategoryDriftModelTable> {
  $$CategoryDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isMainCategory => $composableBuilder(
    column: $table.isMainCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$CategoryDriftModelTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $CategoryDriftModelTable,
          category_drift_model,
          $$CategoryDriftModelTableFilterComposer,
          $$CategoryDriftModelTableOrderingComposer,
          $$CategoryDriftModelTableAnnotationComposer,
          $$CategoryDriftModelTableCreateCompanionBuilder,
          $$CategoryDriftModelTableUpdateCompanionBuilder,
          (
            category_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $CategoryDriftModelTable,
              category_drift_model
            >,
          ),
          category_drift_model,
          PrefetchHooks Function()
        > {
  $$CategoryDriftModelTableTableManager(
    _$AppLocalDatabase db,
    $CategoryDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryDriftModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryDriftModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryDriftModelTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> isMainCategory = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryDriftModelCompanion(
                id: id,
                name: name,
                description: description,
                isMainCategory: isMainCategory,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> isMainCategory = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryDriftModelCompanion.insert(
                id: id,
                name: name,
                description: description,
                isMainCategory: isMainCategory,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoryDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $CategoryDriftModelTable,
      category_drift_model,
      $$CategoryDriftModelTableFilterComposer,
      $$CategoryDriftModelTableOrderingComposer,
      $$CategoryDriftModelTableAnnotationComposer,
      $$CategoryDriftModelTableCreateCompanionBuilder,
      $$CategoryDriftModelTableUpdateCompanionBuilder,
      (
        category_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $CategoryDriftModelTable,
          category_drift_model
        >,
      ),
      category_drift_model,
      PrefetchHooks Function()
    >;
typedef $$BrandCategoryDriftModelTableCreateCompanionBuilder =
    BrandCategoryDriftModelCompanion Function({
      required String id,
      required String brandId,
      required String categoryId,
      Value<int> rowid,
    });
typedef $$BrandCategoryDriftModelTableUpdateCompanionBuilder =
    BrandCategoryDriftModelCompanion Function({
      Value<String> id,
      Value<String> brandId,
      Value<String> categoryId,
      Value<int> rowid,
    });

class $$BrandCategoryDriftModelTableFilterComposer
    extends Composer<_$AppLocalDatabase, $BrandCategoryDriftModelTable> {
  $$BrandCategoryDriftModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrandCategoryDriftModelTableOrderingComposer
    extends Composer<_$AppLocalDatabase, $BrandCategoryDriftModelTable> {
  $$BrandCategoryDriftModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandCategoryDriftModelTableAnnotationComposer
    extends Composer<_$AppLocalDatabase, $BrandCategoryDriftModelTable> {
  $$BrandCategoryDriftModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );
}

class $$BrandCategoryDriftModelTableTableManager
    extends
        RootTableManager<
          _$AppLocalDatabase,
          $BrandCategoryDriftModelTable,
          brand_category_drift_model,
          $$BrandCategoryDriftModelTableFilterComposer,
          $$BrandCategoryDriftModelTableOrderingComposer,
          $$BrandCategoryDriftModelTableAnnotationComposer,
          $$BrandCategoryDriftModelTableCreateCompanionBuilder,
          $$BrandCategoryDriftModelTableUpdateCompanionBuilder,
          (
            brand_category_drift_model,
            BaseReferences<
              _$AppLocalDatabase,
              $BrandCategoryDriftModelTable,
              brand_category_drift_model
            >,
          ),
          brand_category_drift_model,
          PrefetchHooks Function()
        > {
  $$BrandCategoryDriftModelTableTableManager(
    _$AppLocalDatabase db,
    $BrandCategoryDriftModelTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrandCategoryDriftModelTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BrandCategoryDriftModelTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BrandCategoryDriftModelTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> brandId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandCategoryDriftModelCompanion(
                id: id,
                brandId: brandId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String brandId,
                required String categoryId,
                Value<int> rowid = const Value.absent(),
              }) => BrandCategoryDriftModelCompanion.insert(
                id: id,
                brandId: brandId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrandCategoryDriftModelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppLocalDatabase,
      $BrandCategoryDriftModelTable,
      brand_category_drift_model,
      $$BrandCategoryDriftModelTableFilterComposer,
      $$BrandCategoryDriftModelTableOrderingComposer,
      $$BrandCategoryDriftModelTableAnnotationComposer,
      $$BrandCategoryDriftModelTableCreateCompanionBuilder,
      $$BrandCategoryDriftModelTableUpdateCompanionBuilder,
      (
        brand_category_drift_model,
        BaseReferences<
          _$AppLocalDatabase,
          $BrandCategoryDriftModelTable,
          brand_category_drift_model
        >,
      ),
      brand_category_drift_model,
      PrefetchHooks Function()
    >;

class $AppLocalDatabaseManager {
  final _$AppLocalDatabase _db;
  $AppLocalDatabaseManager(this._db);
  $$ProductDriftModelTableTableManager get productDriftModel =>
      $$ProductDriftModelTableTableManager(_db, _db.productDriftModel);
  $$BrandDriftModelTableTableManager get brandDriftModel =>
      $$BrandDriftModelTableTableManager(_db, _db.brandDriftModel);
  $$CategoryDriftModelTableTableManager get categoryDriftModel =>
      $$CategoryDriftModelTableTableManager(_db, _db.categoryDriftModel);
  $$BrandCategoryDriftModelTableTableManager get brandCategoryDriftModel =>
      $$BrandCategoryDriftModelTableTableManager(
        _db,
        _db.brandCategoryDriftModel,
      );
}
