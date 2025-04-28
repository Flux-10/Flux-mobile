import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/widgets/bottomnavbar.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final bool focusBid;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    this.focusBid = false,
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _bidAmountController = TextEditingController();
  final TextEditingController _bidMessageController = TextEditingController();
  final _bidFormKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String _selectedBidType = 'Monetary';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // If focus on bid was requested, open the bids tab
    if (widget.focusBid) {
      _tabController.animateTo(1);
      
      // Set bid type based on task payment mode
      if (widget.task.containsKey('paymentMode')) {
        _selectedBidType = widget.task['paymentMode'];
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bidAmountController.dispose();
    _bidMessageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: AppBar(
        backgroundColor: AppConstants.bg,
        elevation: 0,
        title: Text(
          'Task Details',
          style: GoogleFonts.manrope(
            color: AppConstants.primary,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppConstants.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.outlinebg,
          labelColor: AppConstants.outlinebg,
          unselectedLabelColor: AppConstants.labelText,
          tabs: [
            Tab(text: 'Details'),
            Tab(text: 'Bids (${widget.task['bids']?.length ?? 0})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskDetails(),
          _buildBidsTab(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
  
  Widget _buildTaskDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture
              CircleAvatar(
                radius: 24,
                backgroundColor: AppConstants.labelText.withOpacity(0.2),
                child: Text(
                  widget.task['username'][0].toUpperCase(),
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
                          widget.task['fullName'],
                          style: TextStyle(
                            color: AppConstants.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '@${widget.task['username']}',
                          style: TextStyle(
                            color: AppConstants.labelText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '· ${widget.task['timeAgo']}',
                          style: TextStyle(
                            color: AppConstants.labelText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppConstants.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.task['category'],
                        style: TextStyle(
                          color: AppConstants.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Task title
          Text(
            widget.task['title'],
            style: GoogleFonts.manrope(
              color: AppConstants.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Task description
          Text(
            widget.task['description'],
            style: TextStyle(
              color: AppConstants.primary,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Payment mode badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppConstants.outlinebg.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getPaymentText(widget.task['paymentMode']),
              style: TextStyle(
                color: AppConstants.outlinebg,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats
          Row(
            children: [
              _buildStatItem(
                Icons.comment, 
                '${widget.task['comments']}', 
                'Comments'
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                Icons.gavel, 
                '${widget.task['bids']?.length ?? 0}', 
                'Bids'
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                Icons.favorite, 
                '${widget.task['likes']}', 
                'Likes'
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Bid button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                _tabController.animateTo(1);
              },
              icon: const Icon(Icons.gavel, size: 20),
              label: Text(
                'Place a Bid',
                style: GoogleFonts.manrope(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.outlinebg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Contact poster button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact functionality coming soon')),
                );
              },
              icon: const Icon(Icons.mail_outline, size: 20),
              label: Text(
                'Contact Poster',
                style: GoogleFonts.manrope(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConstants.outlinebg,
                side: BorderSide(color: AppConstants.outlinebg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBidsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Place a bid form
          Card(
            elevation: 0,
            color: AppConstants.primarybg.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: AppConstants.labelText.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _bidFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Place Your Bid',
                      style: GoogleFonts.manrope(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Bid type selection
                    Text(
                      'Bid Type',
                      style: GoogleFonts.manrope(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppConstants.bg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppConstants.labelText.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBidType,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: AppConstants.primary),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: AppConstants.primary),
                          dropdownColor: AppConstants.bg,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedBidType = newValue;
                              });
                            }
                          },
                          items: <String>['Monetary', 'Skill Swap', 'Services']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bid amount
                    Text(
                      _selectedBidType == 'Monetary' ? 'Your Bid Amount' : 'What you offer',
                      style: GoogleFonts.manrope(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bidAmountController,
                      decoration: InputDecoration(
                        hintText: _selectedBidType == 'Monetary' 
                            ? 'E.g., \$25/hour or \$50 fixed' 
                            : 'E.g., Photoshop lessons or Guitar sessions',
                        fillColor: AppConstants.bg,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppConstants.labelText.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppConstants.labelText.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppConstants.outlinebg,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, 
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your bid amount or offer';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bid message
                    Text(
                      'Message (Optional)',
                      style: GoogleFonts.manrope(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bidMessageController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tell them why you\'re the right person for this task...',
                        fillColor: AppConstants.bg,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppConstants.labelText.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppConstants.labelText.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppConstants.outlinebg,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, 
                          vertical: 12,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitBid,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.outlinebg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: AppConstants.outlinebg.withOpacity(0.6),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Submit Bid',
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Existing bids
          Text(
            'Existing Bids',
            style: GoogleFonts.manrope(
              color: AppConstants.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Bids list
          widget.task['bids'] != null && (widget.task['bids'] as List).isNotEmpty
              ? Column(
                  children: List.generate(
                    (widget.task['bids'] as List).length,
                    (index) => _buildBidItem(widget.task['bids'][index], index),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.gavel,
                          size: 48,
                          color: AppConstants.labelText.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No bids yet',
                          style: GoogleFonts.manrope(
                            color: AppConstants.primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to bid on this task!',
                          style: GoogleFonts.manrope(
                            color: AppConstants.labelText,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(IconData icon, String count, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppConstants.primary,
        ),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            color: AppConstants.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
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
    );
  }
  
  Widget _buildBidItem(Map<String, dynamic> bid, int index) {
    final isTopBid = index == 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTopBid 
            ? AppConstants.outlinebg.withOpacity(0.1) 
            : AppConstants.primarybg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTopBid 
              ? AppConstants.outlinebg.withOpacity(0.3) 
              : AppConstants.labelText.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isTopBid 
                ? AppConstants.outlinebg.withOpacity(0.2) 
                : AppConstants.labelText.withOpacity(0.2),
            child: Text(
              bid['user'][0].toUpperCase(),
              style: TextStyle(
                color: isTopBid ? AppConstants.outlinebg : AppConstants.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '@${bid['user']}',
                      style: TextStyle(
                        color: AppConstants.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (isTopBid) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppConstants.outlinebg.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: AppConstants.outlinebg,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Top Bid',
                              style: TextStyle(
                                color: AppConstants.outlinebg,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isTopBid 
                            ? AppConstants.outlinebg.withOpacity(0.2) 
                            : AppConstants.primarybg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        bid['amount'],
                        style: TextStyle(
                          color: isTopBid ? AppConstants.outlinebg : AppConstants.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  bid['message'],
                  style: TextStyle(
                    color: AppConstants.primary.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Bid actions
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact functionality coming soon')),
                        );
                      },
                      icon: Icon(
                        Icons.mail_outline,
                        size: 16,
                        color: isTopBid ? AppConstants.outlinebg : AppConstants.primary,
                      ),
                      label: Text(
                        'Contact',
                        style: TextStyle(
                          color: isTopBid ? AppConstants.outlinebg : AppConstants.primary,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        side: BorderSide(
                          color: isTopBid ? AppConstants.outlinebg : AppConstants.primary,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isTopBid)
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Accept bid functionality coming soon')),
                          );
                        },
                        icon: Icon(
                          Icons.check_circle_outline,
                          size: 16,
                        ),
                        label: Text(
                          'Accept Bid',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.outlinebg,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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
  
  Future<void> _submitBid() async {
    if (_bidFormKey.currentState?.validate() ?? false) {
      // Show loading
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));
        
        // Return success
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your bid has been submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Clear form
          _bidAmountController.clear();
          _bidMessageController.clear();
          
          // Go back to details tab
          _tabController.animateTo(0);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting bid: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
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