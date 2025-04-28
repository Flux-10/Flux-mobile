import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  
  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _replyController = TextEditingController();
  final List<Map<String, dynamic>> _sampleReplies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load sample replies
    _loadReplies();
  }

  Future<void> _loadReplies() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Sample replies data
    final List<Map<String, dynamic>> replies = [
      {
        'username': 'replier1',
        'fullName': 'Reply User 1',
        'text': 'Great post! I totally agree with this.',
        'timeAgo': '45m',
        'likes': 8,
      },
      {
        'username': 'replier2',
        'fullName': 'Reply User 2',
        'text': 'I had a similar experience last week. The campus was so lively!',
        'timeAgo': '1h',
        'likes': 5,
      },
      {
        'username': 'replier3',
        'fullName': 'Reply User 3',
        'text': 'Has anyone else noticed this? I think it\'s becoming a trend.',
        'timeAgo': '2h',
        'likes': 2,
      },
      {
        'username': 'replier4',
        'fullName': 'Reply User 4',
        'text': 'Can you share more details about this? I\'m interested to learn more.',
        'timeAgo': '3h',
        'likes': 3,
      },
    ];

    setState(() {
      _sampleReplies.addAll(replies);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Post',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original post
                  _buildOriginalPost(widget.post),
                  
                  // Divider
                  Divider(color: Colors.grey.shade800, height: 1),
                  
                  // Replies section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Replies',
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  if (_isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: AppConstants.primary),
                      ),
                    )
                  else if (_sampleReplies.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Icon(Icons.chat_bubble_outline, 
                                 color: Colors.grey, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'No replies yet',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to reply!',
                              style: GoogleFonts.manrope(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._sampleReplies.map(_buildReply).toList(),
                ],
              ),
            ),
          ),
          
          // Reply input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(top: BorderSide(color: Colors.grey.shade800)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add a reply...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: AppConstants.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 16),
                    onPressed: () {
                      if (_replyController.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reply functionality coming soon')),
                        );
                        // Clear the input
                        _replyController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalPost(Map<String, dynamic> post) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade800,
                child: Text(
                  post['username'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // User name, handle and post
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name, handle and time
                    Row(
                      children: [
                        Text(
                          post['fullName'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '@${post['username']}',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Post text
                    Text(
                      post['caption'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Time posted
                    Text(
                      'Posted ${post['timeAgo']}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Post content placeholder - would be image or video
          if (post.containsKey('color'))
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 200,
                width: double.infinity,
                color: post['color'],
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 64,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Stats row
          Row(
            children: [
              Text(
                '${post['comments']} Comments',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${post['likes']} Likes',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                Icons.chat_bubble_outline, 
                'Comment'
              ),
              _buildActionButton(
                Icons.repeat, 
                'Refluxx'
              ),
              _buildActionButton(
                Icons.favorite_border, 
                'Like'
              ),
              _buildActionButton(
                Icons.share_outlined, 
                'Share'
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildReply(Map<String, dynamic> reply) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade900, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade800,
            child: Text(
              reply['username'][0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Reply content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, handle and time
                Row(
                  children: [
                    Text(
                      reply['fullName'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '@${reply['username']}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '· ${reply['timeAgo']}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Reply text
                Text(
                  reply['text'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Reply actions
                Row(
                  children: [
                    Icon(Icons.favorite_border, 
                         color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${reply['likes']}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.chat_bubble_outline, 
                         color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label action coming soon')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 