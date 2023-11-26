const months = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'Aug',
  9: 'Sept',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec'
};

// This method converts a date time string to the format of Month Name dd, yyyy
String convertStringToDate(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    return "${months[dateTime.month]} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year.toString()}";
  } catch (e) {
    return "No date";
  }
}