import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class RantsFeed extends StatefulWidget {
  const RantsFeed({Key? key}) : super(key: key);

  @override
  State<RantsFeed> createState() => _RantsFeedState();
}

class _RantsFeedState extends State<RantsFeed> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  
  // Sample data for rants feed
  final List<Map<String, dynamic>> _rantItems = [
    {
      'username': 'frustrated101',
      'fullName': 'Frustrated Student',
      'rantText': 'Why do professors assign so much work right before finals? Do they think their class is the only one we\'re taking? 😫',
      'hasImage': false,
      'imageColor': Colors.purple.shade300,
      'likes': 56,
      'comments': 12,
      'timeAgo': '1h',
    },
    {
      'username': 'caffeinated',
      'fullName': 'Coffee Addict',
      'rantText': 'The campus coffee shop closed early AGAIN! How am I supposed to finish my all-nighter without caffeine?! ☕',
      'hasImage': true,
      'imageColor': Colors.brown.shade300,
      'likes': 34,
      'comments': 8,
      'timeAgo': '3h',
    },
    {
      'username': 'parkingwoes',
      'fullName': 'Parking Hunter',
      'rantText': 'Spent 45 minutes looking for parking today. FORTY-FIVE MINUTES! And then got a ticket because my tire was touching the line. This parking system is a joke. 🚗😡',
      'hasImage': false,
      'imageColor': Colors.orange.shade300,
      'likes': 78,
      'comments': 23,
      'timeAgo': '5h',
    },
    {
      'username': 'dormdrama',
      'fullName': 'Dorm Resident',
      'rantText': 'My roommate\'s alarm has been going off for 30 minutes and they\'re not even here! Make it stop!!! 🔊😭',
      'hasImage': true,
      'imageColor': Colors.red.shade300,
      'likes': 42,
      'comments': 15,
      'timeAgo': '1d',
    },
    {
      'username': 'libraryloner',
      'fullName': 'Library Dweller',
      'rantText': 'Someone is eating chips VERY loudly in the quiet section of the library. I can feel my sanity slipping away with each crunch. 📚',
      'hasImage': false,
      'imageColor': Colors.teal.shade300,
      'likes': 89,
      'comments': 17,
      'timeAgo': '2d',
    },
  ];
  
  // List to hold all rant items including loaded ones
  List<Map<String, dynamic>> _displayedItems = [];
  int _currentPage = 0;
  final int _itemsPerPage = 5;
  
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
        final Map<String, dynamic> newItem = Map.from(_rantItems[i % _rantItems.length]);
        // Update the timeAgo field to make items look different
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
            return _buildTwitterStyleRant(_displayedItems[index]);
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
  
  Widget _buildTwitterStyleRant(Map<String, dynamic> rant) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      color: AppConstants.bg,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(color: AppConstants.labelText.withOpacity(0.3), width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          // Show rant detail if needed, for now just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing rant by ${rant['fullName']}'),
              duration: const Duration(seconds: 1),
            ),
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
                      rant['username'][0].toUpperCase(),
                      style: TextStyle(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // User info and rant content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name, handle and time
                        Row(
                          children: [
                            Text(
                              rant['fullName'],
                              style: TextStyle(
                                color: AppConstants.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '@${rant['username']}',
                              style: TextStyle(
                                color: AppConstants.labelText,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '· ${rant['timeAgo']}',
                              style: TextStyle(
                                color: AppConstants.labelText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        
                        // Rant text
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            rant['rantText'],
                            style: GoogleFonts.manrope(
                              color: AppConstants.primary,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Optional image
              if (rant['hasImage'] == true) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, top: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: rant['imageColor'],
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
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
                      '${rant['comments']}',
                    ),
                    _buildActionButton(
                      Icons.repeat, 
                      'Repost',
                    ),
                    _buildActionButton(
                      Icons.favorite_border, 
                      '${rant['likes']}',
                    ),
                    _buildActionButton(
                      Icons.share_outlined, 
                      'Share',
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
} 