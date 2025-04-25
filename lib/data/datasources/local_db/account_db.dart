class AccountDb {
  const AccountDb._();
  static const AccountDb _instance = AccountDb._();
  static AccountDb get instance => _instance;
  final String tableName = 'my_accounts';
}
