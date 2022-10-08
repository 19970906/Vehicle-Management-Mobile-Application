class Utils {
  static String getWelcomeMessage() {
    final hour = DateTime.now().hour;
    String msg;

    print(hour);

    if (hour > 17) {
      msg = 'Good Evening !';
    } else if (hour > 11) {
      msg = 'Good Afternoon !';
    } else {
      msg = 'Good Morning !';
    }

    // if (hour < 12) {
    //   msg = 'Good Morning User !';
    // } else if (hour > 12 && hour < 18) {
    //   msg = 'Good Afternoon User !';
    // } else {
    //   msg = 'Good Evening User !';
    // }

    return msg;
  }
}
