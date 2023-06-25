import 'dart:async';

import 'package:http/http.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:telegram_bot/command/command.dart';
import 'package:telegram_bot/extensions.dart';
import 'package:telegram_bot/optional.dart';


class TelegramBot {
  final String _token;
  final client = Client();

  final _commandProviders = <TelegramCommandProvider>[];

  final commands = <TelegramBotCommand>[];
  final listeners = <TelegramBotListener>[];

  Telegram? _telegram;
  LongPolling? _longPolling;
  StreamSubscription? _pollingSub;

  TelegramBot(this._token);

  TelegramBot.withCommands(this._token, List<TelegramCommandProvider> commandProviders) {
    _commandProviders.addAll(commandProviders);
  }

  Future<void> start() async {
    _telegram = Telegram(_token);
    _longPolling = LongPolling(_telegram!);
    _pollingSub = _longPolling
        !.onUpdate()
        .listen((event) => _processUpdate(event));

    final delegate = TelegramDelegate(() => _telegram!);

    commands.clear();
    commands.addAll(
      _commandProviders.map((provider) => provider(this, delegate)
        ..onAttach()
      )
    );
    await _longPolling!.start();
    return _pollingSub!.asFuture();
  }

  Future<void> stop() async {
    await _longPolling?.stop();
    await _pollingSub?.cancel();
  }

  Future<User?> getMe() => _telegram?.getMe() ?? Future(() => null);

  void _processUpdate(Update event) {
    if (event.message != null) {
      _logMessage(event.message!);
      final command = parseCommand(event.message!);

      if (command == null) return;
      print('Found command $command');
      commands.where((cmd) => cmd.getCommands().where((c) => c == command).isNotEmpty)
          .firstOrNull?.also((cmd) {
            print('Found matching executor $cmd');
            cmd.execute(event.message!);
          });
    }
  }

  void _logMessage(Message message) {
    var toLog = DateTime.fromMillisecondsSinceEpoch(message.date * 1000, isUtc: true)
        .toString()
        .mapTo((str) => '$str: ${message.from?.firstName ?? ''}')
        .mapTo((str) => '$str${str.isEmpty ? '' : ' '}${message.from?.lastName ?? ''}')
        .mapTo((str) => '$str${message.chat.title?.prepend('@ ') ?? ''} => ')
        .mapTo((str) => '$str${message.text ?? ''}')
        .mapTo((str) => '$str${message.photo.isPresent ? 'sent a photo' : ''}')
        .mapTo((str) => '$str${message.document.isPresent ? 'sent a document' : ''}')
        .mapTo((str) => '$str${message.sticker.isPresent ? 'sent a sticker' : ''}');

    print(toLog);
  }
}