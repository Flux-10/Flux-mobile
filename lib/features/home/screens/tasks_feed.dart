import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/router/routes.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksFeed extends StatefulWidget {
  const TasksFeed({Key? key}) : super(key: key);

  @override
  State<TasksFeed> createState() => _TasksFeedState();
}

class _TasksFeedState extends State<TasksFeed> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  
  // Sample data for tasks feed
  final List<Map<String, dynamic>> _taskItems = [
    {
      'username': 'tutor123',
      'fullName': 'Math Tutor',
      'title': 'Help with Calculus Homework',
      'description': 'Need help understanding derivatives and integrals for upcoming exam. Can meet on campus library.',
      'category': 'Tutoring',
      'paymentMode': 'Monetary',
      'likes': 4,
      'comments': 8,
      'timeAgo': '3h',
      'bids': [
        {
          'user': 'mathwiz',
          'amount': '\$25/hr',
          'message': 'I can help you understand calculus concepts. I\'m a math major.'
        },
        {
          'user': 'calculusPro',
          'amount': '\$30/hr',
          'message': 'PhD student here. Can tutor you with advanced techniques.'
        },
        {
          'user': 'derivativeKing',
          'amount': '\$22/hr',
          'message': 'I\'ve tutored 5 students who all got A\'s. Available tomorrow.'
        }
      ]
    },
    {
      'username': 'movinghelp',
      'fullName': 'Moving Helper',
      'title': 'Need help moving furniture',
      'description': 'Looking for someone to help move heavy furniture from my dorm to new apartment nearby. Will take about 2 hours.',
      'category': 'Moving',
      'paymentMode': 'Skill Swap',
      'likes': 2,
      'comments': 5,
      'timeAgo': '5h',
      'bids': [
        {
          'user': 'strongguy',
          'amount': 'Cooking lessons',
          'message': 'I can help you move. I\'ve done this several times before.'
        },
        {
          'user': 'liftmaster',
          'amount': 'Video editing',
          'message': 'I can bring my truck too if needed.'
        }
      ]
    },
    {
      'username': 'techgeek',
      'fullName': 'Tech Support',
      'title': 'Computer troubleshooting',
      'description': 'My laptop keeps crashing during presentations. Need someone who knows about Windows troubleshooting.',
      'category': 'Tech Help',
      'paymentMode': 'Services',
      'likes': 7,
      'comments': 6,
      'timeAgo': '1d',
      'bids': [
        {
          'user': 'codewizard',
          'amount': 'Math tutoring',
          'message': 'I can fix your laptop issues. Probably just need to update drivers.'
        },
        {
          'user': 'bugfixer',
          'amount': '\$40 flat',
          'message': 'IT student here. Can diagnose hardware and software problems.'
        },
        {
          'user': 'techmage',
          'amount': 'Photography session',
          'message': 'I\'ve fixed similar issues before. Happy to help!'
        }
      ]
    },
    {
      'username': 'errandrunner',
      'fullName': 'Errand Helper',
      'title': 'Pick up groceries',
      'description': 'Need help picking up groceries from the store near campus. I have a list ready, just need someone with a car.',
      'category': 'Errands',
      'paymentMode': 'Monetary',
      'likes': 3,
      'comments': 4,
      'timeAgo': '2d',
      'bids': [
        {
          'user': 'carowner',
          'amount': '\$15 flat',
          'message': 'I can pick them up for you tomorrow afternoon.'
        },
        {
          'user': 'helpfuljoe',
          'amount': '\$20 flat',
          'message': 'Available today after 4pm. Can get it done within an hour.'
        }
      ]
    },
  ];
  
  // List to hold all task items including loaded ones
  List<Map<String, dynamic>> _displayedItems = [];
  int _currentPage = 0;
  final int _itemsPerPage = 4;
  
  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    
    // Add scroll listener to load more items when reaching the end
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 && !_isLoading) {
        _loadMoreItems();
      }
    });
  }
  
  Future<void> _loadMoreItems() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      // Add new items (in real app would be API call)
      final startIndex = _currentPage * _itemsPerPage;
      for (int i = 0; i < _itemsPerPage; i++) {
        final Map<String, dynamic> newItem = Map.from(_taskItems[i % _taskItems.length]);
        newItem['timeAgo'] = '${startIndex + i + 1}h';
        _displayedItems.add(newItem);
      }
      _currentPage++;
      _isLoading = false;
    });
  }
  
  Future<void> _refreshFeed() async {
    setState(() {
      _isLoading = true;
      _displayedItems = [];
      _currentPage = 0;
    });
    
    await Future.delayed(const Duration(milliseconds: 1000));
    _loadMoreItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshFeed,
      color: AppConstants.outlinebg,
      backgroundColor: Colors.white,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: _displayedItems.length + 1, // +1 for the loading indicator
        itemBuilder: (context, index) {
          if (index < _displayedItems.length) {
            return _buildTwitterStyleTaskPost(_displayedItems[index]);
          } else if (_isLoading) {
            // Show loading indicator at the bottom
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppConstants.outlinebg,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
  
  Widget _buildTwitterStyleTaskPost(Map<String, dynamic> task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      color: AppConstants.bg,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(color: AppConstants.labelText.withOpacity(0.3), width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to task detail
          Navigator.pushNamed(
            context,
            Routes.postDetail,
            arguments: {'post': task},
          );
        },
        child: Padding(
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
                    backgroundColor: AppConstants.labelText.withOpacity(0.2),
                    child: Text(
                      task['username'][0].toUpperCase(),
                      style: TextStyle(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // User info and post content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name, handle and time
                        Row(
                          children: [
                            Text(
                              task['fullName'],
                              style: TextStyle(
                                color: AppConstants.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '@${task['username']}',
                              style: TextStyle(
                                color: AppConstants.labelText,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '· ${task['timeAgo']}',
                              style: TextStyle(
                                color: AppConstants.labelText,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppConstants.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                task['category'],
                                style: TextStyle(
                                  color: AppConstants.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Task title in bold
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Text(
                            task['title'],
                            style: GoogleFonts.manrope(
                              color: AppConstants.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        
                        // Task description
                        Text(
                          task['description'],
                          style: TextStyle(
                            color: AppConstants.primary,
                            fontSize: 15,
                          ),
                        ),
                        
                        // Payment mode badge
                        Container(
                          margin: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppConstants.outlinebg.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getPaymentText(task['paymentMode']),
                            style: TextStyle(
                              color: AppConstants.outlinebg,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Auction/Bidding Section Preview
              if (task['bids'] != null && task['bids'].isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${task['bids'].length} bids available',
                            style: TextStyle(
                              color: AppConstants.outlinebg,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          
                          // Show all bids text button
                          TextButton(
                            onPressed: () {
                              // Navigate to task detail focusing on bids
                              Navigator.pushNamed(
                                context,
                                Routes.postDetail,
                                arguments: {'post': task, 'focusBids': true},
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: AppConstants.outlinebg,
                            ),
                            child: Text(
                              'See all →',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Preview of top bid
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppConstants.outlinebg.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppConstants.outlinebg.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppConstants.outlinebg.withOpacity(0.2),
                              child: Text(
                                task['bids'][0]['user'][0].toUpperCase(),
                                style: TextStyle(
                                  color: AppConstants.outlinebg,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '@${task['bids'][0]['user']}',
                                        style: TextStyle(
                                          color: AppConstants.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppConstants.outlinebg.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          task['bids'][0]['amount'],
                                          style: TextStyle(
                                            color: AppConstants.outlinebg,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task['bids'][0]['message'],
                                    style: TextStyle(
                                      color: AppConstants.primary.withOpacity(0.8),
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Show second bid preview if available
                      if (task['bids'].length > 1) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppConstants.outlinebg.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppConstants.outlinebg.withOpacity(0.05),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppConstants.outlinebg.withOpacity(0.1),
                                child: Text(
                                  task['bids'][1]['user'][0].toUpperCase(),
                                  style: TextStyle(
                                    color: AppConstants.outlinebg,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '@${task['bids'][1]['user']}',
                                          style: TextStyle(
                                            color: AppConstants.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppConstants.outlinebg.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            task['bids'][1]['amount'],
                                            style: TextStyle(
                                              color: AppConstants.outlinebg,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      task['bids'][1]['message'],
                                      style: TextStyle(
                                        color: AppConstants.primary.withOpacity(0.7),
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.only(left: 60.0, top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      Icons.chat_bubble_outline, 
                      '${task['comments']}',
                      onTap: () {
                        // Navigate to task detail focusing on comments
                        Navigator.pushNamed(
                          context,
                          Routes.postDetail,
                          arguments: {'post': task, 'focusComments': true},
                        );
                      },
                    ),
                    _buildActionButton(
                      Icons.repeat, 
                      'Share'
                    ),
                    _buildActionButton(
                      Icons.favorite_border, 
                      '${task['likes']}'
                    ),
                    
                    // Bid button
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.outlinebg,
                            AppConstants.outlinebg.withBlue(180),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.outlinebg.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to task detail to bid
                          Navigator.pushNamed(
                            context,
                            Routes.postDetail,
                            arguments: {'post': task, 'focusBid': true},
                          );
                        },
                        icon: Icon(Icons.gavel, size: 16),
                        label: Text('Bid'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          textStyle: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppConstants.labelText,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: AppConstants.labelText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getPaymentText(String mode) {
    switch (mode) {
      case 'Monetary':
        return '💰 Money payment';
      case 'Skill Swap':
        return '🔄 Skill swap';
      case 'Services':
        return '🤝 Service exchange';
      default:
        return mode;
    }
  }
} 