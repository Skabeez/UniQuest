import '../database.dart';

class QuestCodeRedemptionsTable
    extends SupabaseTable<QuestCodeRedemptionsRow> {
  @override
  String get tableName => 'quest_code_redemptions';

  @override
  QuestCodeRedemptionsRow createRow(Map<String, dynamic> data) =>
      QuestCodeRedemptionsRow(data);
}

class QuestCodeRedemptionsRow extends SupabaseDataRow {
  QuestCodeRedemptionsRow(super.data);

  @override
  SupabaseTable get table => QuestCodeRedemptionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get questCodeId => getField<String>('quest_code_id')!;
  set questCodeId(String value) => setField<String>('quest_code_id', value);

  DateTime get redeemedAt => getField<DateTime>('redeemed_at')!;
  set redeemedAt(DateTime value) => setField<DateTime>('redeemed_at', value);
}
