String shortDate(DateTime datetime) {
    String month = months()[datetime.month-1];
    return "$month ${datetime.day}, ${datetime.year}";
}

String shortTime(DateTime datetime) {
    int h = datetime.hour > 12
        ? datetime.hour-12
        : datetime.hour;
    if (datetime.hour == 0) {
        h = 12;
    }
    int m = datetime.minute;
    String p = period(datetime);
    String minute = m < 10 ? "0${m}" : "${m}";
    return "${h}:${minute}${p}";
}

String longTime(DateTime datetime) {
    String date = shortDate(datetime);
    String time = shortTime(datetime);
    return "${date} @ ${time}";
}

List<String> months() {
    return <String>[
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    ];
}

String period(DateTime datetime) {
    return datetime.hour >= 12 ? "pm" : "am";
}
