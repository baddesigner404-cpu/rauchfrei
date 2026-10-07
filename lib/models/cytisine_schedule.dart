class CytisineSchedule {
  static int getPillsForDay(int day) {
    if (day >= 1 && day <= 3) return 6;
    if (day >= 4 && day <= 12) return 5;
    if (day >= 13 && day <= 16) return 4;
    if (day >= 17 && day <= 20) return 3;
    if (day >= 21 && day <= 25) return 2; // Usually 1-2, let's max at 2
    return 0; // Course finished
  }

  static String getIntervalForDay(int day) {
    if (day >= 1 && day <= 3) return "Каждые 2 часа";
    if (day >= 4 && day <= 12) return "Каждые 2.5 часа";
    if (day >= 13 && day <= 16) return "Каждые 3 часа";
    if (day >= 17 && day <= 20) return "Каждые 5 часов";
    if (day >= 21 && day <= 25) return "1-2 таблетки в день";
    return "Курс завершен";
  }

  static int getCurrentDayOfCourse(DateTime startDate) {
    final now = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(start).inDays + 1;
  }
}
