class SearchHelper {
  String roomId(String a, String b) {
    int firstUserInt = 0;
    int secondUserInt = 0;

    for (int i = 0; i <= a.length - 1; i++) {
      firstUserInt += firstUserInt + a.codeUnitAt(i);
    }

    for (int i = 0; i <= b.length - 1; i++) {
      secondUserInt += secondUserInt + b.codeUnitAt(i);
    }

    print(firstUserInt.toString() + ' ,' + secondUserInt.toString());

    if (firstUserInt > secondUserInt) {
      return a + '_' + b;
    } else {
      return b + '_' + a;
    }
  }
}
