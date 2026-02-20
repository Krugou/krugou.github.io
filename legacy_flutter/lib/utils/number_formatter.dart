class NumberFormatter {
  static String format(double number) {
    if (number < 1000) {
      return number.toStringAsFixed(1);
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number < 1000000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else {
      return '${(number / 1000000000000).toStringAsFixed(1)}T';
    }
  }
  
  static String formatInt(int number) {
    return format(number.toDouble());
  }
  
  static String formatTime(double seconds) {
    final int hours = (seconds / 3600).floor();
    final int minutes = ((seconds % 3600) / 60).floor();
    final int secs = (seconds % 60).floor();
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
  
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }
}