import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:flutter/material.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/repositories/user_repository.dart';
import 'package:uni_quest/services/cache_service_impl.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  Local state fields for this page.

  String selectedTab = '\"All\"';

  String taskPriority = '\"High\"';

  bool isCompleted = true;

  // ============================================================================
  // OFFLINE ARCHITECTURE - Profile Management
  // ============================================================================

  // Services
  final CacheServiceImpl _cacheService = CacheServiceImpl();
  final UserRepository _userRepository =
      UserRepository(Supabase.instance.client);

  // Local state for profile
  ProfilesRow? _userProfile;
  Map<String, dynamic>? _userStats;
  // ignore: unused_field
  bool _isLoadingProfile = false;
  // ignore: unused_field
  bool _isShowingCachedData = false;
  // ignore: unused_field
  String? _lastError;

  // Getters for UI
  ProfilesRow? get userProfile => _userProfile;
  Map<String, dynamic>? get userStats => _userStats;
  bool get isLoadingProfile => _isLoadingProfile;
  bool get isShowingCachedData => _isShowingCachedData;
  bool get isOnline => true; // Online-first mode
  String? get lastError => _lastError;

  // ============================================================================
  // READ OPERATIONS (with offline support)
  // ============================================================================

  /// Load user profile
  /// Automatically uses cache if offline
  Future<void> loadUserProfile(String userId) async {
    _isLoadingProfile = true;
    _lastError = null;
    _isShowingCachedData = false;

    try {
      final result = await _userRepository.getUserById(userId);

      if (result.isSuccess) {
        final profile = result.data;
        if (profile != null) {
          _userProfile = profile;
          _isShowingCachedData = false;
          // Cache for offline use
          _cacheService.cacheUserProfile(profile);
        }
      } else {
        // Load from cache on error
        await _loadProfileFromCache(userId);
        _isShowingCachedData = true;
        _lastError = 'Showing cached profile - you are offline';
      }
    } catch (e) {
      await _loadProfileFromCache(userId);
      _isShowingCachedData = true;
      _lastError = 'Using cached profile due to connection error';
    } finally {
      _isLoadingProfile = false;
    }
  }

  /// Load user statistics
  Future<void> loadUserStats(String userId) async {
    try {
      if (isOnline) {
        // Online - fetch from repository
        final cached = await _cacheService.getCachedUserStats(userId);
        _userStats = cached;
      } else {
        // Offline - use cached stats
        final cached = await _cacheService.getCachedUserStats(userId);
        _userStats = cached;
        _isShowingCachedData = true;
      }
    } catch (e) {
      _lastError = 'Failed to load stats';
    }
  }

  /// Refresh profile (pull-to-refresh)
  Future<void> refreshProfile(String userId) async {
    if (!isOnline) {
      _lastError = 'Cannot refresh while offline';
      return;
    }

    await loadUserProfile(userId);
    await loadUserStats(userId);
  }

  // ============================================================================
  // WRITE OPERATIONS (require online connectivity)
  // ============================================================================

  /// Update username
  /// Requires internet connection
  Future<bool> updateUsername({
    required String userId,
    required String newUsername,
    required BuildContext context,
  }) async {
    // Check connectivity first
    if (!isOnline) {
      _showOfflineDialog(
        context,
        'Cannot update username while offline',
        'Please connect to the internet to update your profile.',
      );
      return false;
    }

    try {
      final result = await _userRepository.updateUsername(
        userId: userId,
        username: newUsername,
      );

      return result.when(
        success: (profile) {
          _userProfile = profile;
          _cacheService.cacheUserProfile(profile);
          _showSuccessSnackbar(context, 'Username updated successfully!');
          return true;
        },
        failure: (error) {
          _showErrorSnackbar(
              context, 'Failed to update username: \${error.toString()}');
          return false;
        },
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error updating username: \${e.toString()}');
      return false;
    }
  }

  /// Update bio
  /// Requires internet connection
  Future<bool> updateBio({
    required String userId,
    required String newBio,
    required BuildContext context,
  }) async {
    if (!isOnline) {
      _showOfflineDialog(
        context,
        'Cannot update bio while offline',
        'Please connect to the internet to update your profile.',
      );
      return false;
    }

    try {
      final result = await _userRepository.updateBio(
        userId: userId,
        bio: newBio,
      );

      return result.when(
        success: (profile) {
          _userProfile = profile;
          _cacheService.cacheUserProfile(profile);
          _showSuccessSnackbar(context, 'Bio updated!');
          return true;
        },
        failure: (error) {
          _showErrorSnackbar(context, 'Failed to update bio');
          return false;
        },
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error updating bio');
      return false;
    }
  }

  /// Update avatar
  /// Requires internet connection
  Future<bool> updateAvatar({
    required String userId,
    required String avatarUrl,
    required BuildContext context,
  }) async {
    if (!isOnline) {
      _showOfflineDialog(
        context,
        'Cannot update avatar while offline',
        'Please connect to the internet to update your avatar.',
      );
      return false;
    }

    try {
      final result = await _userRepository.updateAvatar(
        userId: userId,
        avatarUrl: avatarUrl,
      );

      return result.when(
        success: (profile) {
          _userProfile = profile;
          _cacheService.cacheUserProfile(profile);
          _showSuccessSnackbar(context, 'Avatar updated!');
          return true;
        },
        failure: (error) {
          _showErrorSnackbar(context, 'Failed to update avatar');
          return false;
        },
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error updating avatar');
      return false;
    }
  }

  /// Equip cosmetic (namecard, border)
  /// Requires internet connection
  Future<bool> equipCosmetic({
    required String userId,
    required String cosmeticId,
    required String cosmeticType,
    required BuildContext context,
  }) async {
    if (!isOnline) {
      _showOfflineDialog(
        context,
        'Cannot equip cosmetics while offline',
        'Please connect to the internet to change cosmetics.',
      );
      return false;
    }

    try {
      final result = cosmeticType == 'namecard'
          ? await _userRepository.equipNamecard(
              userId: userId,
              namecardId: cosmeticId,
            )
          : await _userRepository.equipBorder(
              userId: userId,
              borderId: cosmeticId,
            );

      return result.when(
        success: (profile) {
          _userProfile = profile;
          _cacheService.cacheUserProfile(profile);
          _showSuccessSnackbar(context, 'Cosmetic equipped!');
          return true;
        },
        failure: (error) {
          _showErrorSnackbar(context, 'Failed to equip cosmetic');
          return false;
        },
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error equipping cosmetic');
      return false;
    }
  }

  // ============================================================================
  // CACHE FALLBACK METHODS (private)
  // ============================================================================

  Future<void> _loadProfileFromCache(String userId) async {
    final cached = await _cacheService.getCachedUserProfile(userId);
    if (cached != null) {
      _userProfile = cached;
    } else {
      _lastError = 'No cached profile available';
    }
  }

  // ============================================================================
  // UI FEEDBACK HELPERS (private)
  // ============================================================================

  void _showOfflineDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ============================================================================
  // CONNECTIVITY MONITORING
  // ============================================================================

  void startConnectivityMonitoring() {
    // Connectivity monitoring placeholder
  }

  @override
  void initState(BuildContext context) {
    // Initialize services
    _cacheService.initialize();

    // Start monitoring
    startConnectivityMonitoring();
  }

  @override
  void dispose() {}
}
