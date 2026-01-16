import '../database.dart';

class QuestsTable extends SupabaseTable<QuestsRow> {
  @override
  String get tableName => 'quests';

  @override
  QuestsRow createRow(Map<String, dynamic> data) => QuestsRow(data);
}

class QuestsRow extends SupabaseDataRow {
  QuestsRow(super.data);

  @override
  SupabaseTable get table => QuestsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get description => getField<String>('description')!;
  set description(String value) => setField<String>('description', value);

  String get verificationCode => getField<String>('verification_code')!;
  set verificationCode(String value) => setField<String>('verification_code', value);

  int get xpReward => getField<int>('xp_reward')!;
  set xpReward(int value) => setField<int>('xp_reward', value);

  bool get isRetired => getField<bool>('is_retired') ?? false;
  set isRetired(bool value) => setField<bool>('is_retired', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
