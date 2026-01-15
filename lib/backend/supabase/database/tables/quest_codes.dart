import '../database.dart';

class QuestCodesTable extends SupabaseTable<QuestCodesRow> {
  @override
  String get tableName => 'quest_codes';

  @override
  QuestCodesRow createRow(Map<String, dynamic> data) => QuestCodesRow(data);
}

class QuestCodesRow extends SupabaseDataRow {
  QuestCodesRow(super.data);

  @override
  SupabaseTable get table => QuestCodesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get questId => getField<String>('quest_id')!;
  set questId(String value) => setField<String>('quest_id', value);

  String get verificationCode => getField<String>('verification_code')!;
  set verificationCode(String value) =>
      setField<String>('verification_code', value);

  String get locationHint => getField<String>('location_hint')!;
  set locationHint(String value) => setField<String>('location_hint', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
