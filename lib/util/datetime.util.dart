String shortTime(DateTime datetime) {
    String month = months()[datetime.month];
    return "$month ${datetime.day}, ${datetime.year}";
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
