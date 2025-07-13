# InstaCap Development Setup Guide

## Quick Start

### Prerequisites
1. **Node.js** - Download from [nodejs.org](https://nodejs.org/)
2. **Flutter** - Install from [flutter.dev](https://flutter.dev/docs/get-started/install)
3. **Firebase CLI** - Install with: `npm install -g firebase-tools`

### Option 1: Automated Setup (Recommended)

Run the automated development environment setup:

```powershell
# Navigate to project root
cd "d:\Flutter\Insta"

# Run the development environment setup script
.\scripts\start-dev-environment.ps1
```

This will automatically start:
- Firebase Emulators (Auth, Firestore, Storage)
- Backend API Server
- Flutter Web App

### Option 2: Manual Setup

#### 1. Start Firebase Emulators
```powershell
cd "d:\Flutter\Insta"
firebase emulators:start --only auth,firestore,storage
```

#### 2. Start Backend Server
```powershell
cd "d:\Flutter\Insta\Backend"
npm install  # First time only
npm start
```

#### 3. Start Flutter App
```powershell
cd "d:\Flutter\Insta\Frontend\insta_cap"
flutter pub get  # First time only
flutter run -d chrome --web-port 57707
```

## Service URLs

- **Firebase Emulator UI**: http://localhost:4000
- **Backend API**: http://localhost:3000
- **Flutter Web App**: http://localhost:57707

## Fixed Issues

✅ **CORS Error**: Updated backend to allow Flutter dev server port (57707)
✅ **API Connection**: Configured to use local backend for development
✅ **Firebase Emulators**: Added proper configuration and error handling
✅ **Development Scripts**: Created automated setup scripts
✅ **Text Color Issues**: Implemented comprehensive theme-aware text color system
✅ **Dark Theme Support**: Full dark theme implementation with proper contrast
✅ **Glass Effect Text**: Fixed text visibility on glass morphism backgrounds
✅ **Form Field Colors**: Theme-aware input fields with proper contrast
✅ **Button Text Colors**: Consistent text colors across all button types

## New Features Added

🎨 **Theme-Aware Text System**: 
- Automatic text color adjustment based on current theme
- Specialized text widgets for different contexts (glass, gradient, surface)
- Proper contrast ratios for accessibility

🌙 **Enhanced Dark Theme**:
- Complete dark theme implementation
- Proper text contrast on all backgrounds
- Theme persistence across app restarts

🔧 **Development Tools**:
- Text color test screen for theme validation
- Theme helper methods for consistent styling
- Automated theme switching support

## Testing Text Colors

To test the text color fixes:

1. **Access Test Screen**: Add this route to your router or create a temporary button:
   ```dart
   // Navigate to test screen
   Navigator.push(context, MaterialPageRoute(
     builder: (context) => const TextColorTestScreen(),
   ));
   ```

2. **Test Both Themes**: Use the theme toggle button to switch between light and dark themes

3. **Verify Contrast**: Check that all text is readable in both themes

4. **Test Contexts**: Verify text on:
   - Regular surfaces (cards, containers)
   - Glass morphism backgrounds
   - Gradient backgrounds
   - Form fields and inputs

## Text Color Guidelines

When adding new UI components:

1. **Use ThemedText Widgets**:
   ```dart
   // Instead of Text() with hardcoded colors
   ThemedText('Your text', onGlass: true) // For glass backgrounds
   ThemedText('Your text', onGradient: true) // For gradient backgrounds
   ThemedText('Your text', primary: false) // For secondary text
   ```

2. **Use Theme Helper Methods**:
   ```dart
   // Get theme-appropriate colors
   color: AppTheme.getTextColor(context, primary: true)
   color: AppTheme.getTextOnGlassColor(context)
   ```

3. **Follow Color Constants**:
   - `AppColors.textPrimary` / `AppColors.textPrimaryDark`
   - `AppColors.textSecondary` / `AppColors.textSecondaryDark`
   - `AppColors.textOnGlass` / `AppColors.textOnGlassDark`
   - `AppColors.textOnGradient`

## Troubleshooting

### Firebase Emulator Connection Issues
If you see Firebase emulator connection errors:
1. Make sure Firebase CLI is installed: `npm install -g firebase-tools`
2. Start emulators manually: `firebase emulators:start --only auth,firestore,storage`
3. The app will fallback to production Firebase if emulators aren't available

### CORS Errors
If you still see CORS errors:
1. Make sure the backend server is running on port 3000
2. Check that the frontend is using the correct API URL (localhost:3000)
3. Restart both backend and frontend

### API Connection Issues
If API health checks fail:
1. Verify backend server is running: http://localhost:3000/health
2. Check network connectivity
3. Ensure no firewall is blocking the connection

## Production Deployment

To switch to production mode:

1. Update `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'https://instacap.onrender.com/api';
   ```

2. Update `lib/services/api_test_service.dart`:
   ```dart
   static const String baseUrl = 'https://instacap.onrender.com';
   ```

3. Comment out emulator connection in `main.dart`:
   ```dart
   // await FirebaseEmulatorConfig.connectToEmulators();
   ```
