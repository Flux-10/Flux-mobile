class Tweetpost {
  final String id;
  final String uid;
  final String name;
  final String username;
  final String timestamp;
  final int likeCount;
  final List<String> likedBy;

  Tweetpost({
    required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.timestamp,
    required this.likeCount,
    required this.likedBy,
  });

}
