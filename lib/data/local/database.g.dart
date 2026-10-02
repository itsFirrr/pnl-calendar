// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TradesTable extends Trades with TableInfo<$TradesTable, Trade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryTimeMeta = const VerificationMeta(
    'entryTime',
  );
  @override
  late final GeneratedColumn<DateTime> entryTime = GeneratedColumn<DateTime>(
    'entry_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exitTimeMeta = const VerificationMeta(
    'exitTime',
  );
  @override
  late final GeneratedColumn<DateTime> exitTime = GeneratedColumn<DateTime>(
    'exit_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pairMeta = const VerificationMeta('pair');
  @override
  late final GeneratedColumn<String> pair = GeneratedColumn<String>(
    'pair',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TradeDirection, String>
  direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TradeDirection>($TradesTable.$converterdirection);
  static const VerificationMeta _lotSizeMeta = const VerificationMeta(
    'lotSize',
  );
  @override
  late final GeneratedColumn<double> lotSize = GeneratedColumn<double>(
    'lot_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryPriceMeta = const VerificationMeta(
    'entryPrice',
  );
  @override
  late final GeneratedColumn<double> entryPrice = GeneratedColumn<double>(
    'entry_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slPriceMeta = const VerificationMeta(
    'slPrice',
  );
  @override
  late final GeneratedColumn<double> slPrice = GeneratedColumn<double>(
    'sl_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tpPriceMeta = const VerificationMeta(
    'tpPrice',
  );
  @override
  late final GeneratedColumn<double> tpPrice = GeneratedColumn<double>(
    'tp_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exitPriceMeta = const VerificationMeta(
    'exitPrice',
  );
  @override
  late final GeneratedColumn<double> exitPrice = GeneratedColumn<double>(
    'exit_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultUscMeta = const VerificationMeta(
    'resultUsc',
  );
  @override
  late final GeneratedColumn<double> resultUsc = GeneratedColumn<double>(
    'result_usc',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TradeStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TradeStatus>($TradesTable.$converterstatus);
  static const VerificationMeta _entryReasonMeta = const VerificationMeta(
    'entryReason',
  );
  @override
  late final GeneratedColumn<String> entryReason = GeneratedColumn<String>(
    'entry_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exitReasonMeta = const VerificationMeta(
    'exitReason',
  );
  @override
  late final GeneratedColumn<String> exitReason = GeneratedColumn<String>(
    'exit_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EmotionState?, String> emotion =
      GeneratedColumn<String>(
        'emotion',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<EmotionState?>($TradesTable.$converteremotionn);
  static const VerificationMeta _screenshotPathMeta = const VerificationMeta(
    'screenshotPath',
  );
  @override
  late final GeneratedColumn<String> screenshotPath = GeneratedColumn<String>(
    'screenshot_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    entryTime,
    exitTime,
    pair,
    direction,
    lotSize,
    entryPrice,
    slPrice,
    tpPrice,
    exitPrice,
    resultUsc,
    status,
    entryReason,
    exitReason,
    emotion,
    screenshotPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('entry_time')) {
      context.handle(
        _entryTimeMeta,
        entryTime.isAcceptableOrUnknown(data['entry_time']!, _entryTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_entryTimeMeta);
    }
    if (data.containsKey('exit_time')) {
      context.handle(
        _exitTimeMeta,
        exitTime.isAcceptableOrUnknown(data['exit_time']!, _exitTimeMeta),
      );
    }
    if (data.containsKey('pair')) {
      context.handle(
        _pairMeta,
        pair.isAcceptableOrUnknown(data['pair']!, _pairMeta),
      );
    } else if (isInserting) {
      context.missing(_pairMeta);
    }
    if (data.containsKey('lot_size')) {
      context.handle(
        _lotSizeMeta,
        lotSize.isAcceptableOrUnknown(data['lot_size']!, _lotSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_lotSizeMeta);
    }
    if (data.containsKey('entry_price')) {
      context.handle(
        _entryPriceMeta,
        entryPrice.isAcceptableOrUnknown(data['entry_price']!, _entryPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_entryPriceMeta);
    }
    if (data.containsKey('sl_price')) {
      context.handle(
        _slPriceMeta,
        slPrice.isAcceptableOrUnknown(data['sl_price']!, _slPriceMeta),
      );
    }
    if (data.containsKey('tp_price')) {
      context.handle(
        _tpPriceMeta,
        tpPrice.isAcceptableOrUnknown(data['tp_price']!, _tpPriceMeta),
      );
    }
    if (data.containsKey('exit_price')) {
      context.handle(
        _exitPriceMeta,
        exitPrice.isAcceptableOrUnknown(data['exit_price']!, _exitPriceMeta),
      );
    }
    if (data.containsKey('result_usc')) {
      context.handle(
        _resultUscMeta,
        resultUsc.isAcceptableOrUnknown(data['result_usc']!, _resultUscMeta),
      );
    } else if (isInserting) {
      context.missing(_resultUscMeta);
    }
    if (data.containsKey('entry_reason')) {
      context.handle(
        _entryReasonMeta,
        entryReason.isAcceptableOrUnknown(
          data['entry_reason']!,
          _entryReasonMeta,
        ),
      );
    }
    if (data.containsKey('exit_reason')) {
      context.handle(
        _exitReasonMeta,
        exitReason.isAcceptableOrUnknown(data['exit_reason']!, _exitReasonMeta),
      );
    }
    if (data.containsKey('screenshot_path')) {
      context.handle(
        _screenshotPathMeta,
        screenshotPath.isAcceptableOrUnknown(
          data['screenshot_path']!,
          _screenshotPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      entryTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_time'],
      )!,
      exitTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exit_time'],
      ),
      pair: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pair'],
      )!,
      direction: $TradesTable.$converterdirection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}direction'],
        )!,
      ),
      lotSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lot_size'],
      )!,
      entryPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}entry_price'],
      )!,
      slPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sl_price'],
      ),
      tpPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tp_price'],
      ),
      exitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exit_price'],
      ),
      resultUsc: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}result_usc'],
      )!,
      status: $TradesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      entryReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_reason'],
      ),
      exitReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exit_reason'],
      ),
      emotion: $TradesTable.$converteremotionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emotion'],
        ),
      ),
      screenshotPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}screenshot_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TradesTable createAlias(String alias) {
    return $TradesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TradeDirection, String, String>
  $converterdirection = const EnumNameConverter<TradeDirection>(
    TradeDirection.values,
  );
  static JsonTypeConverter2<TradeStatus, String, String> $converterstatus =
      const EnumNameConverter<TradeStatus>(TradeStatus.values);
  static JsonTypeConverter2<EmotionState, String, String> $converteremotion =
      const EnumNameConverter<EmotionState>(EmotionState.values);
  static JsonTypeConverter2<EmotionState?, String?, String?>
  $converteremotionn = JsonTypeConverter2.asNullable($converteremotion);
}

class Trade extends DataClass implements Insertable<Trade> {
  final int id;
  final DateTime date;
  final DateTime entryTime;
  final DateTime? exitTime;
  final String pair;
  final TradeDirection direction;
  final double lotSize;
  final double entryPrice;
  final double? slPrice;
  final double? tpPrice;
  final double? exitPrice;
  final double resultUsc;
  final TradeStatus status;
  final String? entryReason;
  final String? exitReason;
  final EmotionState? emotion;
  final String? screenshotPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Trade({
    required this.id,
    required this.date,
    required this.entryTime,
    this.exitTime,
    required this.pair,
    required this.direction,
    required this.lotSize,
    required this.entryPrice,
    this.slPrice,
    this.tpPrice,
    this.exitPrice,
    required this.resultUsc,
    required this.status,
    this.entryReason,
    this.exitReason,
    this.emotion,
    this.screenshotPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['entry_time'] = Variable<DateTime>(entryTime);
    if (!nullToAbsent || exitTime != null) {
      map['exit_time'] = Variable<DateTime>(exitTime);
    }
    map['pair'] = Variable<String>(pair);
    {
      map['direction'] = Variable<String>(
        $TradesTable.$converterdirection.toSql(direction),
      );
    }
    map['lot_size'] = Variable<double>(lotSize);
    map['entry_price'] = Variable<double>(entryPrice);
    if (!nullToAbsent || slPrice != null) {
      map['sl_price'] = Variable<double>(slPrice);
    }
    if (!nullToAbsent || tpPrice != null) {
      map['tp_price'] = Variable<double>(tpPrice);
    }
    if (!nullToAbsent || exitPrice != null) {
      map['exit_price'] = Variable<double>(exitPrice);
    }
    map['result_usc'] = Variable<double>(resultUsc);
    {
      map['status'] = Variable<String>(
        $TradesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || entryReason != null) {
      map['entry_reason'] = Variable<String>(entryReason);
    }
    if (!nullToAbsent || exitReason != null) {
      map['exit_reason'] = Variable<String>(exitReason);
    }
    if (!nullToAbsent || emotion != null) {
      map['emotion'] = Variable<String>(
        $TradesTable.$converteremotionn.toSql(emotion),
      );
    }
    if (!nullToAbsent || screenshotPath != null) {
      map['screenshot_path'] = Variable<String>(screenshotPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TradesCompanion toCompanion(bool nullToAbsent) {
    return TradesCompanion(
      id: Value(id),
      date: Value(date),
      entryTime: Value(entryTime),
      exitTime: exitTime == null && nullToAbsent
          ? const Value.absent()
          : Value(exitTime),
      pair: Value(pair),
      direction: Value(direction),
      lotSize: Value(lotSize),
      entryPrice: Value(entryPrice),
      slPrice: slPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(slPrice),
      tpPrice: tpPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(tpPrice),
      exitPrice: exitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(exitPrice),
      resultUsc: Value(resultUsc),
      status: Value(status),
      entryReason: entryReason == null && nullToAbsent
          ? const Value.absent()
          : Value(entryReason),
      exitReason: exitReason == null && nullToAbsent
          ? const Value.absent()
          : Value(exitReason),
      emotion: emotion == null && nullToAbsent
          ? const Value.absent()
          : Value(emotion),
      screenshotPath: screenshotPath == null && nullToAbsent
          ? const Value.absent()
          : Value(screenshotPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Trade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trade(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      entryTime: serializer.fromJson<DateTime>(json['entryTime']),
      exitTime: serializer.fromJson<DateTime?>(json['exitTime']),
      pair: serializer.fromJson<String>(json['pair']),
      direction: $TradesTable.$converterdirection.fromJson(
        serializer.fromJson<String>(json['direction']),
      ),
      lotSize: serializer.fromJson<double>(json['lotSize']),
      entryPrice: serializer.fromJson<double>(json['entryPrice']),
      slPrice: serializer.fromJson<double?>(json['slPrice']),
      tpPrice: serializer.fromJson<double?>(json['tpPrice']),
      exitPrice: serializer.fromJson<double?>(json['exitPrice']),
      resultUsc: serializer.fromJson<double>(json['resultUsc']),
      status: $TradesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      entryReason: serializer.fromJson<String?>(json['entryReason']),
      exitReason: serializer.fromJson<String?>(json['exitReason']),
      emotion: $TradesTable.$converteremotionn.fromJson(
        serializer.fromJson<String?>(json['emotion']),
      ),
      screenshotPath: serializer.fromJson<String?>(json['screenshotPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'entryTime': serializer.toJson<DateTime>(entryTime),
      'exitTime': serializer.toJson<DateTime?>(exitTime),
      'pair': serializer.toJson<String>(pair),
      'direction': serializer.toJson<String>(
        $TradesTable.$converterdirection.toJson(direction),
      ),
      'lotSize': serializer.toJson<double>(lotSize),
      'entryPrice': serializer.toJson<double>(entryPrice),
      'slPrice': serializer.toJson<double?>(slPrice),
      'tpPrice': serializer.toJson<double?>(tpPrice),
      'exitPrice': serializer.toJson<double?>(exitPrice),
      'resultUsc': serializer.toJson<double>(resultUsc),
      'status': serializer.toJson<String>(
        $TradesTable.$converterstatus.toJson(status),
      ),
      'entryReason': serializer.toJson<String?>(entryReason),
      'exitReason': serializer.toJson<String?>(exitReason),
      'emotion': serializer.toJson<String?>(
        $TradesTable.$converteremotionn.toJson(emotion),
      ),
      'screenshotPath': serializer.toJson<String?>(screenshotPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Trade copyWith({
    int? id,
    DateTime? date,
    DateTime? entryTime,
    Value<DateTime?> exitTime = const Value.absent(),
    String? pair,
    TradeDirection? direction,
    double? lotSize,
    double? entryPrice,
    Value<double?> slPrice = const Value.absent(),
    Value<double?> tpPrice = const Value.absent(),
    Value<double?> exitPrice = const Value.absent(),
    double? resultUsc,
    TradeStatus? status,
    Value<String?> entryReason = const Value.absent(),
    Value<String?> exitReason = const Value.absent(),
    Value<EmotionState?> emotion = const Value.absent(),
    Value<String?> screenshotPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Trade(
    id: id ?? this.id,
    date: date ?? this.date,
    entryTime: entryTime ?? this.entryTime,
    exitTime: exitTime.present ? exitTime.value : this.exitTime,
    pair: pair ?? this.pair,
    direction: direction ?? this.direction,
    lotSize: lotSize ?? this.lotSize,
    entryPrice: entryPrice ?? this.entryPrice,
    slPrice: slPrice.present ? slPrice.value : this.slPrice,
    tpPrice: tpPrice.present ? tpPrice.value : this.tpPrice,
    exitPrice: exitPrice.present ? exitPrice.value : this.exitPrice,
    resultUsc: resultUsc ?? this.resultUsc,
    status: status ?? this.status,
    entryReason: entryReason.present ? entryReason.value : this.entryReason,
    exitReason: exitReason.present ? exitReason.value : this.exitReason,
    emotion: emotion.present ? emotion.value : this.emotion,
    screenshotPath: screenshotPath.present
        ? screenshotPath.value
        : this.screenshotPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Trade copyWithCompanion(TradesCompanion data) {
    return Trade(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      entryTime: data.entryTime.present ? data.entryTime.value : this.entryTime,
      exitTime: data.exitTime.present ? data.exitTime.value : this.exitTime,
      pair: data.pair.present ? data.pair.value : this.pair,
      direction: data.direction.present ? data.direction.value : this.direction,
      lotSize: data.lotSize.present ? data.lotSize.value : this.lotSize,
      entryPrice: data.entryPrice.present
          ? data.entryPrice.value
          : this.entryPrice,
      slPrice: data.slPrice.present ? data.slPrice.value : this.slPrice,
      tpPrice: data.tpPrice.present ? data.tpPrice.value : this.tpPrice,
      exitPrice: data.exitPrice.present ? data.exitPrice.value : this.exitPrice,
      resultUsc: data.resultUsc.present ? data.resultUsc.value : this.resultUsc,
      status: data.status.present ? data.status.value : this.status,
      entryReason: data.entryReason.present
          ? data.entryReason.value
          : this.entryReason,
      exitReason: data.exitReason.present
          ? data.exitReason.value
          : this.exitReason,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      screenshotPath: data.screenshotPath.present
          ? data.screenshotPath.value
          : this.screenshotPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trade(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('entryTime: $entryTime, ')
          ..write('exitTime: $exitTime, ')
          ..write('pair: $pair, ')
          ..write('direction: $direction, ')
          ..write('lotSize: $lotSize, ')
          ..write('entryPrice: $entryPrice, ')
          ..write('slPrice: $slPrice, ')
          ..write('tpPrice: $tpPrice, ')
          ..write('exitPrice: $exitPrice, ')
          ..write('resultUsc: $resultUsc, ')
          ..write('status: $status, ')
          ..write('entryReason: $entryReason, ')
          ..write('exitReason: $exitReason, ')
          ..write('emotion: $emotion, ')
          ..write('screenshotPath: $screenshotPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    entryTime,
    exitTime,
    pair,
    direction,
    lotSize,
    entryPrice,
    slPrice,
    tpPrice,
    exitPrice,
    resultUsc,
    status,
    entryReason,
    exitReason,
    emotion,
    screenshotPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trade &&
          other.id == this.id &&
          other.date == this.date &&
          other.entryTime == this.entryTime &&
          other.exitTime == this.exitTime &&
          other.pair == this.pair &&
          other.direction == this.direction &&
          other.lotSize == this.lotSize &&
          other.entryPrice == this.entryPrice &&
          other.slPrice == this.slPrice &&
          other.tpPrice == this.tpPrice &&
          other.exitPrice == this.exitPrice &&
          other.resultUsc == this.resultUsc &&
          other.status == this.status &&
          other.entryReason == this.entryReason &&
          other.exitReason == this.exitReason &&
          other.emotion == this.emotion &&
          other.screenshotPath == this.screenshotPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TradesCompanion extends UpdateCompanion<Trade> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> entryTime;
  final Value<DateTime?> exitTime;
  final Value<String> pair;
  final Value<TradeDirection> direction;
  final Value<double> lotSize;
  final Value<double> entryPrice;
  final Value<double?> slPrice;
  final Value<double?> tpPrice;
  final Value<double?> exitPrice;
  final Value<double> resultUsc;
  final Value<TradeStatus> status;
  final Value<String?> entryReason;
  final Value<String?> exitReason;
  final Value<EmotionState?> emotion;
  final Value<String?> screenshotPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TradesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.entryTime = const Value.absent(),
    this.exitTime = const Value.absent(),
    this.pair = const Value.absent(),
    this.direction = const Value.absent(),
    this.lotSize = const Value.absent(),
    this.entryPrice = const Value.absent(),
    this.slPrice = const Value.absent(),
    this.tpPrice = const Value.absent(),
    this.exitPrice = const Value.absent(),
    this.resultUsc = const Value.absent(),
    this.status = const Value.absent(),
    this.entryReason = const Value.absent(),
    this.exitReason = const Value.absent(),
    this.emotion = const Value.absent(),
    this.screenshotPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TradesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required DateTime entryTime,
    this.exitTime = const Value.absent(),
    required String pair,
    required TradeDirection direction,
    required double lotSize,
    required double entryPrice,
    this.slPrice = const Value.absent(),
    this.tpPrice = const Value.absent(),
    this.exitPrice = const Value.absent(),
    required double resultUsc,
    required TradeStatus status,
    this.entryReason = const Value.absent(),
    this.exitReason = const Value.absent(),
    this.emotion = const Value.absent(),
    this.screenshotPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date),
       entryTime = Value(entryTime),
       pair = Value(pair),
       direction = Value(direction),
       lotSize = Value(lotSize),
       entryPrice = Value(entryPrice),
       resultUsc = Value(resultUsc),
       status = Value(status);
  static Insertable<Trade> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? entryTime,
    Expression<DateTime>? exitTime,
    Expression<String>? pair,
    Expression<String>? direction,
    Expression<double>? lotSize,
    Expression<double>? entryPrice,
    Expression<double>? slPrice,
    Expression<double>? tpPrice,
    Expression<double>? exitPrice,
    Expression<double>? resultUsc,
    Expression<String>? status,
    Expression<String>? entryReason,
    Expression<String>? exitReason,
    Expression<String>? emotion,
    Expression<String>? screenshotPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (entryTime != null) 'entry_time': entryTime,
      if (exitTime != null) 'exit_time': exitTime,
      if (pair != null) 'pair': pair,
      if (direction != null) 'direction': direction,
      if (lotSize != null) 'lot_size': lotSize,
      if (entryPrice != null) 'entry_price': entryPrice,
      if (slPrice != null) 'sl_price': slPrice,
      if (tpPrice != null) 'tp_price': tpPrice,
      if (exitPrice != null) 'exit_price': exitPrice,
      if (resultUsc != null) 'result_usc': resultUsc,
      if (status != null) 'status': status,
      if (entryReason != null) 'entry_reason': entryReason,
      if (exitReason != null) 'exit_reason': exitReason,
      if (emotion != null) 'emotion': emotion,
      if (screenshotPath != null) 'screenshot_path': screenshotPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TradesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime>? entryTime,
    Value<DateTime?>? exitTime,
    Value<String>? pair,
    Value<TradeDirection>? direction,
    Value<double>? lotSize,
    Value<double>? entryPrice,
    Value<double?>? slPrice,
    Value<double?>? tpPrice,
    Value<double?>? exitPrice,
    Value<double>? resultUsc,
    Value<TradeStatus>? status,
    Value<String?>? entryReason,
    Value<String?>? exitReason,
    Value<EmotionState?>? emotion,
    Value<String?>? screenshotPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TradesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      pair: pair ?? this.pair,
      direction: direction ?? this.direction,
      lotSize: lotSize ?? this.lotSize,
      entryPrice: entryPrice ?? this.entryPrice,
      slPrice: slPrice ?? this.slPrice,
      tpPrice: tpPrice ?? this.tpPrice,
      exitPrice: exitPrice ?? this.exitPrice,
      resultUsc: resultUsc ?? this.resultUsc,
      status: status ?? this.status,
      entryReason: entryReason ?? this.entryReason,
      exitReason: exitReason ?? this.exitReason,
      emotion: emotion ?? this.emotion,
      screenshotPath: screenshotPath ?? this.screenshotPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (entryTime.present) {
      map['entry_time'] = Variable<DateTime>(entryTime.value);
    }
    if (exitTime.present) {
      map['exit_time'] = Variable<DateTime>(exitTime.value);
    }
    if (pair.present) {
      map['pair'] = Variable<String>(pair.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(
        $TradesTable.$converterdirection.toSql(direction.value),
      );
    }
    if (lotSize.present) {
      map['lot_size'] = Variable<double>(lotSize.value);
    }
    if (entryPrice.present) {
      map['entry_price'] = Variable<double>(entryPrice.value);
    }
    if (slPrice.present) {
      map['sl_price'] = Variable<double>(slPrice.value);
    }
    if (tpPrice.present) {
      map['tp_price'] = Variable<double>(tpPrice.value);
    }
    if (exitPrice.present) {
      map['exit_price'] = Variable<double>(exitPrice.value);
    }
    if (resultUsc.present) {
      map['result_usc'] = Variable<double>(resultUsc.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TradesTable.$converterstatus.toSql(status.value),
      );
    }
    if (entryReason.present) {
      map['entry_reason'] = Variable<String>(entryReason.value);
    }
    if (exitReason.present) {
      map['exit_reason'] = Variable<String>(exitReason.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<String>(
        $TradesTable.$converteremotionn.toSql(emotion.value),
      );
    }
    if (screenshotPath.present) {
      map['screenshot_path'] = Variable<String>(screenshotPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('entryTime: $entryTime, ')
          ..write('exitTime: $exitTime, ')
          ..write('pair: $pair, ')
          ..write('direction: $direction, ')
          ..write('lotSize: $lotSize, ')
          ..write('entryPrice: $entryPrice, ')
          ..write('slPrice: $slPrice, ')
          ..write('tpPrice: $tpPrice, ')
          ..write('exitPrice: $exitPrice, ')
          ..write('resultUsc: $resultUsc, ')
          ..write('status: $status, ')
          ..write('entryReason: $entryReason, ')
          ..write('exitReason: $exitReason, ')
          ..write('emotion: $emotion, ')
          ..write('screenshotPath: $screenshotPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TradesTable trades = $TradesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [trades];
}

typedef $$TradesTableCreateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  required DateTime date,
  required DateTime entryTime,
  Value<DateTime?> exitTime,
  required String pair,
  required TradeDirection direction,
  required double lotSize,
  required double entryPrice,
  Value<double?> slPrice,
  Value<double?> tpPrice,
  Value<double?> exitPrice,
  required double resultUsc,
  required TradeStatus status,
  Value<String?> entryReason,
  Value<String?> exitReason,
  Value<EmotionState?> emotion,
  Value<String?> screenshotPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TradesTableUpdateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<DateTime> entryTime,
  Value<DateTime?> exitTime,
  Value<String> pair,
  Value<TradeDirection> direction,
  Value<double> lotSize,
  Value<double> entryPrice,
  Value<double?> slPrice,
  Value<double?> tpPrice,
  Value<double?> exitPrice,
  Value<double> resultUsc,
  Value<TradeStatus> status,
  Value<String?> entryReason,
  Value<String?> exitReason,
  Value<EmotionState?> emotion,
  Value<String?> screenshotPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$TradesTableFilterComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exitTime => $composableBuilder(
    column: $table.exitTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pair => $composableBuilder(
    column: $table.pair,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TradeDirection, TradeDirection, String>
  get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get lotSize => $composableBuilder(
    column: $table.lotSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get entryPrice => $composableBuilder(
    column: $table.entryPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get slPrice => $composableBuilder(
    column: $table.slPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tpPrice => $composableBuilder(
    column: $table.tpPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exitPrice => $composableBuilder(
    column: $table.exitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get resultUsc => $composableBuilder(
    column: $table.resultUsc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TradeStatus, TradeStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get entryReason => $composableBuilder(
    column: $table.entryReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exitReason => $composableBuilder(
    column: $table.exitReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmotionState?, EmotionState, String>
  get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get screenshotPath => $composableBuilder(
    column: $table.screenshotPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TradesTableOrderingComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exitTime => $composableBuilder(
    column: $table.exitTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pair => $composableBuilder(
    column: $table.pair,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lotSize => $composableBuilder(
    column: $table.lotSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get entryPrice => $composableBuilder(
    column: $table.entryPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get slPrice => $composableBuilder(
    column: $table.slPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tpPrice => $composableBuilder(
    column: $table.tpPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exitPrice => $composableBuilder(
    column: $table.exitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get resultUsc => $composableBuilder(
    column: $table.resultUsc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryReason => $composableBuilder(
    column: $table.entryReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exitReason => $composableBuilder(
    column: $table.exitReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get screenshotPath => $composableBuilder(
    column: $table.screenshotPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTime =>
      $composableBuilder(column: $table.entryTime, builder: (column) => column);

  GeneratedColumn<DateTime> get exitTime =>
      $composableBuilder(column: $table.exitTime, builder: (column) => column);

  GeneratedColumn<String> get pair =>
      $composableBuilder(column: $table.pair, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TradeDirection, String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<double> get lotSize =>
      $composableBuilder(column: $table.lotSize, builder: (column) => column);

  GeneratedColumn<double> get entryPrice => $composableBuilder(
    column: $table.entryPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get slPrice =>
      $composableBuilder(column: $table.slPrice, builder: (column) => column);

  GeneratedColumn<double> get tpPrice =>
      $composableBuilder(column: $table.tpPrice, builder: (column) => column);

  GeneratedColumn<double> get exitPrice =>
      $composableBuilder(column: $table.exitPrice, builder: (column) => column);

  GeneratedColumn<double> get resultUsc =>
      $composableBuilder(column: $table.resultUsc, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TradeStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get entryReason => $composableBuilder(
    column: $table.entryReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exitReason => $composableBuilder(
    column: $table.exitReason,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EmotionState?, String> get emotion =>
      $composableBuilder(column: $table.emotion, builder: (column) => column);

  GeneratedColumn<String> get screenshotPath => $composableBuilder(
    column: $table.screenshotPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TradesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TradesTable,
          Trade,
          $$TradesTableFilterComposer,
          $$TradesTableOrderingComposer,
          $$TradesTableAnnotationComposer,
          $$TradesTableCreateCompanionBuilder,
          $$TradesTableUpdateCompanionBuilder,
          (Trade, BaseReferences<_$AppDatabase, $TradesTable, Trade>),
          Trade,
          PrefetchHooks Function()
        > {
  $$TradesTableTableManager(_$AppDatabase db, $TradesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> entryTime = const Value.absent(),
                Value<DateTime?> exitTime = const Value.absent(),
                Value<String> pair = const Value.absent(),
                Value<TradeDirection> direction = const Value.absent(),
                Value<double> lotSize = const Value.absent(),
                Value<double> entryPrice = const Value.absent(),
                Value<double?> slPrice = const Value.absent(),
                Value<double?> tpPrice = const Value.absent(),
                Value<double?> exitPrice = const Value.absent(),
                Value<double> resultUsc = const Value.absent(),
                Value<TradeStatus> status = const Value.absent(),
                Value<String?> entryReason = const Value.absent(),
                Value<String?> exitReason = const Value.absent(),
                Value<EmotionState?> emotion = const Value.absent(),
                Value<String?> screenshotPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TradesCompanion(
                id: id,
                date: date,
                entryTime: entryTime,
                exitTime: exitTime,
                pair: pair,
                direction: direction,
                lotSize: lotSize,
                entryPrice: entryPrice,
                slPrice: slPrice,
                tpPrice: tpPrice,
                exitPrice: exitPrice,
                resultUsc: resultUsc,
                status: status,
                entryReason: entryReason,
                exitReason: exitReason,
                emotion: emotion,
                screenshotPath: screenshotPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required DateTime entryTime,
                Value<DateTime?> exitTime = const Value.absent(),
                required String pair,
                required TradeDirection direction,
                required double lotSize,
                required double entryPrice,
                Value<double?> slPrice = const Value.absent(),
                Value<double?> tpPrice = const Value.absent(),
                Value<double?> exitPrice = const Value.absent(),
                required double resultUsc,
                required TradeStatus status,
                Value<String?> entryReason = const Value.absent(),
                Value<String?> exitReason = const Value.absent(),
                Value<EmotionState?> emotion = const Value.absent(),
                Value<String?> screenshotPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TradesCompanion.insert(
                id: id,
                date: date,
                entryTime: entryTime,
                exitTime: exitTime,
                pair: pair,
                direction: direction,
                lotSize: lotSize,
                entryPrice: entryPrice,
                slPrice: slPrice,
                tpPrice: tpPrice,
                exitPrice: exitPrice,
                resultUsc: resultUsc,
                status: status,
                entryReason: entryReason,
                exitReason: exitReason,
                emotion: emotion,
                screenshotPath: screenshotPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TradesTable, Trade>(table),
                  BaseReferences<_$AppDatabase, $TradesTable, Trade>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TradesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TradesTable,
      Trade,
      $$TradesTableFilterComposer,
      $$TradesTableOrderingComposer,
      $$TradesTableAnnotationComposer,
      $$TradesTableCreateCompanionBuilder,
      $$TradesTableUpdateCompanionBuilder,
      (Trade, BaseReferences<_$AppDatabase, $TradesTable, Trade>),
      Trade,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TradesTableTableManager get trades =>
      $$TradesTableTableManager(_db, _db.trades);
}
