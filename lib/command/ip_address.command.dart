import 'package:teledart/model.dart';
import 'package:telegram_bot/command/command.dart';

class IpAddressCommand extends TelegramBotCommand {
  IpAddressCommand({ required super.bot, required super.telegramDelegate });

  @override
  void execute(Message message) async {
    final uri = Uri.parse('https://checkip.amazonaws.com');
    final response = await bot.client.get(uri);
    final body = response.body;

    await telegram.sendMessage(
        message.chat.id,
        body,
        replyToMessageId: message.messageId,
        disableNotification: true
    );
  }

  @override
  void onAttach() {
    print('$this attached');
  }

  @override
  List<String> getCommands() {
    return ['/ipaddress'];
  }

}