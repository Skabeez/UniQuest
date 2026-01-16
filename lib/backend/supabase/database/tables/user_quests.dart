import '../database.dart';

class UserQuestsTable extends SupabaseTable<UserQuestsRow> {
  @override
  String get tableName => 'user_quests';

  @override
  UserQuestsRow createRow(Map<String, dynamic> data) => UserQuestsRow(data);
}

class UserQuestsRow extends SupabaseDataRow {
  UserQuestsRow(super.data);

  @override
  SupabaseTable get table => UserQuestsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get questId => getField<String>('quest_id')!;
  set questId(String value) => setField<String>('quest_id', value);

  bool get isRedeemed => getField<bool>('is_redeemed') ?? false;
  set isRedeemed(bool value) => setField<bool>('is_redeemed', value);

  DateTime? get redeemedAt => getField<DateTime>('redeemed_at');
  set redeemedAt(DateTime? value) => setField<DateTime>('redeemed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
