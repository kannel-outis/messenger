extension dateFormat on String {
  String getTime() {
    final String rawDateTimeString = this;
    var dateAndTime = rawDateTimeString.split(" ");
    final String time = dateAndTime.last;
    var splitTime = time.split(":").sublist(0, 2);
    int.parse(splitTime.first) > 12
        ? splitTime.insert(2, "PM")
        : splitTime.insert(2, "AM");
    final String processedTime = splitTime.join(":");
    return processedTime;
  }
}

extension capitalizeString on String {
  String capitalize() {
    List<String> listOfChar = this.split("");
    listOfChar.replaceRange(0, 1, [listOfChar.first.toUpperCase()]);
    return listOfChar.join("");
  }
}
