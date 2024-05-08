import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

enum AccountType { wakatime, custom }

@freezed
sealed class Account with _$Account {
  const factory Account() = AccountData;
  const factory Account.wakatime({
    required String accessToken,
  }) = AccountWakatime;
  const factory Account.custom({
    required String serverUrl,
    required String apiKey,
  }) = AccountCustom;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
