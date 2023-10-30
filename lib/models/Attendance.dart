class Attendance {
  DateTime startDateTime;
  DateTime endDateTime;
  double latitude;
  double longitude;
  bool isEnded;

  Attendance(this.startDateTime, this.endDateTime, this.latitude,
      this.longitude, this.isEnded);

  // Add a method to convert an instance of Attendance to a CSV string
  String toCsvString() {
    return '${startDateTime.toIso8601String()},${endDateTime.toIso8601String()},$latitude,$longitude,$isEnded';
  }

  // Add a factory method to parse a CSV string back to an instance of Attendance
  factory Attendance.fromCsvString(String csvString) {
    final parts = csvString.split(',');
    if (parts.length != 5) {
      throw const FormatException('Invalid CSV format');
    }
    return Attendance(
      DateTime.parse(parts[0]),
      DateTime.parse(parts[1]),
      double.parse(parts[2]),
      double.parse(parts[3]),
      bool.parse(parts[4]),
    );
  }
}
