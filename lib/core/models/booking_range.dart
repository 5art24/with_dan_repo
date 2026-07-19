class BookingRange {
  final DateTime startDate;
  final DateTime endDate;

  BookingRange({
    required this.startDate,
    required this.endDate,
  });

  //To check if today falls within this reserved range
  bool contains(DateTime date) {
   // We filter the time (hours and minutes) for an accurate day-only comparison
    final checkDate = DateTime(date.year, date.month, date.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    return (checkDate.isAtSameMomentAs(start) || checkDate.isAfter(start)) &&
           (checkDate.isAtSameMomentAs(end) || checkDate.isBefore(end));
  }
}