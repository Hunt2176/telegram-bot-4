import 'package:telegram_bot/bot.dart';
import 'package:telegram_bot/command/ip_address.command.dart';

void main(List<String> args) async {
  print(args);
  var token = args[0];

  final bot = TelegramBot.withCommands(token, [
    (bot, delegate) => IpAddressCommand(bot: bot, telegramDelegate: delegate)
  ]);
  await bot.start();

  print('Done');
}