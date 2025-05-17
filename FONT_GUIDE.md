# Font Installation Guide

## Steps to Install Inter Font:

1. Visit Google Fonts: https://fonts.google.com/specimen/Inter?query=inter

2. Click the "Download family" button to download the full font family

3. Extract the ZIP file you downloaded

4. Copy these font files to the `fonts` directory in your project:
   - Inter-Regular.ttf
   - Inter-Medium.ttf
   - Inter-SemiBold.ttf
   - Inter-Bold.ttf

5. Make sure the paths in your pubspec.yaml match these font files:
   ```yaml
   fonts:
     - family: Inter
       fonts:
         - asset: fonts/Inter-Regular.ttf
         - asset: fonts/Inter-Medium.ttf
           weight: 500
         - asset: fonts/Inter-SemiBold.ttf
           weight: 600
         - asset: fonts/Inter-Bold.ttf
           weight: 700
   ```

6. Run `flutter pub get` to update your dependencies

7. Restart your app to see the new fonts applied
