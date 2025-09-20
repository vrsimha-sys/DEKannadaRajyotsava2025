# Render Manual Dashboard Configuration

Since the render.yaml Blueprint approach may not be working, here's the manual configuration for Render dashboard:

## Step 1: Create New Static Site
1. Go to Render Dashboard: https://dashboard.render.com
2. Click "New +" → "Static Site"
3. Connect your GitHub repository: `vrsimha-sys/DEKannadaRajyotsava2025`

## Step 2: Configure Build Settings

**Basic Settings:**
- **Name**: `de-kannada-rajyotsava-tournament`
- **Environment**: `Static Site` (NOT Web Service)
- **Branch**: `main`
- **Root Directory**: Leave empty (use repository root)

**Build & Deploy:**
- **Build Command**: 
  ```bash
  chmod +x build.sh && ./build.sh
  ```

- **Publish Directory**: 
  ```
  flutter_web/build/web
  ```

**Advanced Settings:**
- **Auto-Deploy**: Yes
- **Pull Request Previews**: Optional

## Step 3: Environment Variables
Add these in the Environment section:
- `FLUTTER_WEB` = `true`
- `NODE_ENV` = `production`

## Step 4: Deploy
Click "Create Static Site" and monitor the build logs.

## Alternative Build Commands (if main fails):

**Option 1 - Direct Flutter Install:**
```bash
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz -o flutter.tar.xz && tar xf flutter.tar.xz && export PATH="$PATH:$PWD/flutter/bin" && flutter config --enable-web && cd flutter_web && flutter pub get && flutter build web --release --web-renderer html
```

**Option 2 - Git Clone Flutter:**
```bash
git clone https://github.com/flutter/flutter.git -b stable --depth 1 && export PATH="$PATH:$PWD/flutter/bin" && flutter config --enable-web && cd flutter_web && flutter pub get && flutter build web --release
```

## Important Notes:
- Make sure you select "Static Site" NOT "Web Service"
- The build process takes 5-10 minutes due to Flutter SDK download
- Monitor build logs for any Flutter-specific errors
- Ensure flutter_web/pubspec.yaml is properly configured

## Troubleshooting:
If build still fails:
1. Check that build.sh has executable permissions
2. Verify flutter_web directory structure
3. Check pubspec.yaml for syntax errors
4. Review build logs for Flutter-specific issues