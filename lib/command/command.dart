import 'dart:async';

import 'package:teledart/model.dart';
import 'package:teledart/telegram.dart';
import 'package:telegram_bot/bot.dart';

abstract class TelegramBotCommand extends _TelegramBotItemBase {

  TelegramBotCommand({ required super.bot, required super.telegramDelegate });

  List<String> getCommands();
}

abstract class TelegramBotListener extends _TelegramBotItemBase {

  TelegramBotListener({ required super.bot, required super.telegramDelegate });

  List<String> onContains();
}

abstract class _TelegramBotItemBase {
  TelegramBot bot;
  late TelegramDelegate _telegramDelegate;

  Telegram get telegram => _telegramDelegate.telegram;

  _TelegramBotItemBase({ required this.bot, required telegramDelegate }) {
    _telegramDelegate = telegramDelegate;
  }

  FutureOr<void> execute(Message message);

  void onAttach() {}
}

class TelegramDelegate {
  late Telegram Function() _telegramProvider;

  Telegram get telegram => _telegramProvider();

  TelegramDelegate(Telegram Function() telegramProvider) {
    _telegramProvider = telegramProvider;
  }
}

String? parseCommand(Message message) {
  var entity = message.entities?.where((e) => e.type == 'bot_command').firstOrNull;

  if (entity == null || message.text == null) return null;
  return message.text!.substring(entity.offset, entity.length);
}

typedef TelegramCommandProvider = TelegramBotCommand Function(TelegramBot bot, TelegramDelegate telegram);