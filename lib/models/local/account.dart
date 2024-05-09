import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
sealed class Account with _$Account {
  const factory Account() = AccountData;

  const factory Account.wakatime({
    required String accessToken,
    required String refreshToken,
    required DateTime tokenExpire,
  }) = AccountWakatime;

  const factory Account.custom({
    required String serverUrl,
    required String apiKey,
  }) = AccountCustom;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
