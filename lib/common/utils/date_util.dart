class DateUtil {
  /// Formats a [DateTime] into a human-readable "time ago" string.
  ///
  /// Examples: "1 second ago", "5 minutes ago", "2 hours ago", "yesterday",
  /// "3 days ago", "2 weeks ago", "1 month ago", "2 years ago".
  static String ago(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 5) {
      return 'just now';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      // Approximately 4 weeks
      final weeks = (difference.inDays / 7).round();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      // Approximately 12 months
      final months = (difference.inDays / 30).round();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).round();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}
