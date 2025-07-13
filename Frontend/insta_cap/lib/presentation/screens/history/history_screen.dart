import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/caption_provider.dart';
import '../../../models/caption_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CaptionProvider>(context, listen: false).loadHistory();
    });
  }

  List<CaptionData> _getFilteredCaptions(List<CaptionData> captions) {
    var filtered = captions;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((caption) =>
              caption.caption
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              caption.platform
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              caption.style.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter
    switch (_selectedFilter) {
      case 'saved':
        filtered = filtered.where((caption) => caption.saved).toList();
        break;
      case 'instagram':
        filtered = filtered
            .where((caption) => caption.platform == 'instagram')
            .toList();
        break;
      case 'facebook':
        filtered = filtered
            .where((caption) => caption.platform == 'facebook')
            .toList();
        break;
      case 'twitter':
        filtered =
            filtered.where((caption) => caption.platform == 'twitter').toList();
        break;
      case 'linkedin':
        filtered = filtered
            .where((caption) => caption.platform == 'linkedin')
            .toList();
        break;
    }

    return filtered;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Caption copied to clipboard!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _deleteCaption(String captionId) async {
    final captionProvider =
        Provider.of<CaptionProvider>(context, listen: false);
    final success = await captionProvider.deleteCaption(captionId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Caption deleted successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to delete caption'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caption History'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<CaptionProvider>(context, listen: false)
                  .loadHistory();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          FadeInDown(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search captions...',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Saved', 'saved'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Instagram', 'instagram'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Facebook', 'facebook'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Twitter', 'twitter'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('LinkedIn', 'linkedin'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // History List
          Expanded(
            child: Consumer<CaptionProvider>(
              builder: (context, captionProvider, child) {
                if (captionProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (captionProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: AppColors.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error loading history',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          captionProvider.error!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () => captionProvider.loadHistory(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final filteredCaptions =
                    _getFilteredCaptions(captionProvider.history);

                if (filteredCaptions.isEmpty) {
                  return Center(
                    child: FadeInUp(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64.sp,
                            color: AppColors.grey400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _searchQuery.isNotEmpty || _selectedFilter != 'all'
                                ? 'No captions match your filters'
                                : 'No caption history yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _searchQuery.isNotEmpty || _selectedFilter != 'all'
                                ? 'Try adjusting your search or filters'
                                : 'Start generating captions to see them here',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.grey600,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  itemCount: filteredCaptions.length,
                  itemBuilder: (context, index) {
                    final caption = filteredCaptions[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: _buildCaptionCard(caption),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.grey300,
      ),
    );
  }

  Widget _buildCaptionCard(CaptionData caption) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getPlatformColor(caption.platform)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    caption.platform.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getPlatformColor(caption.platform),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    caption.style.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Spacer(),
                if (caption.saved)
                  Icon(
                    Icons.favorite,
                    size: 16.sp,
                    color: AppColors.error,
                  ),
                SizedBox(width: 8.w),
                Text(
                  _formatDate(caption.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),

          // Caption Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              caption.caption,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 12.h),

          // Stats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildStatItem(
                  Icons.text_fields,
                  '${caption.metadata.characterCount} chars',
                ),
                SizedBox(width: 16.w),
                _buildStatItem(
                  Icons.tag,
                  '${caption.metadata.hashtagCount} tags',
                ),
                SizedBox(width: 16.w),
                _buildStatItem(
                  Icons.mood,
                  '${caption.metadata.emojis.length} emojis',
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Action Buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(caption.caption),
                    icon: Icon(Icons.copy, size: 16.sp),
                    label: const Text('Copy'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                OutlinedButton(
                  onPressed: caption.id != null
                      ? () => _deleteCaption(caption.id!)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                  ),
                  child: Icon(Icons.delete_outline, size: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey600,
              ),
        ),
      ],
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM dd').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
