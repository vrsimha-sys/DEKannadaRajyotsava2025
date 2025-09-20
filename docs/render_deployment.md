# Render Deployment Instructions for Flutter Web

## Deployment Type: Static Site

### Step 1: Create Render Account
1. Go to [render.com](https://render.com)
2. Sign up or log in with your GitHub account

### Step 2: Connect Repository
1. Click "New +" → "Static Site"
2. Connect your GitHub repository: `vrsimha-sys/DEKannadaRajyotsava2025`
3. Select the repository from the list

### Step 3: Configure Build Settings

**Basic Settings:**
- **Name**: `de-kannada-rajyotsava-tournament`
- **Environment**: `Static Site`
- **Branch**: `main`
- **Root Directory**: `/` (leave empty)

**Build Settings:**
- **Build Command**: 
  ```bash
  curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.9-stable.tar.xz -o flutter.tar.xz && tar xf flutter.tar.xz && export PATH="$PATH:$PWD/flutter/bin" && flutter config --enable-web && cd flutter_web && flutter pub get && flutter build web --release --web-renderer html
  ```
- **Publish Directory**: `flutter_web/build/web`

**Advanced Settings:**
- **Auto-Deploy**: Yes
- **Pull Request Previews**: Yes (optional)

### Step 4: Environment Variables (Optional)
- `FLUTTER_WEB=true`
- `NODE_ENV=production`

### Step 5: Deploy
1. Click "Create Static Site"
2. Render will start building your Flutter web app
3. Build process takes 5-10 minutes
4. You'll get a URL like: `https://your-app-name.onrender.com`

### Troubleshooting

**Build Fails:**
- Check that flutter_web directory exists
- Ensure pubspec.yaml is properly formatted
- Verify all dependencies are compatible with web

**Blank Page:**
- Check browser console for errors
- Ensure base href is set correctly in web/index.html
- Verify CORS settings for Google Sheets API

**Slow Loading:**
- Use `--web-renderer html` for better compatibility
- Enable web caching headers

### Manual Deployment Alternative

If automatic build fails, you can build locally and deploy:

1. Build locally:
   ```bash
   cd flutter_web
   flutter build web --release
   ```

2. Deploy build/web folder as static files

### Custom Domain (Optional)
1. Go to your Render service dashboard
2. Settings → Custom Domains
3. Add your domain and configure DNS

### Important Notes
- Flutter web apps are Single Page Applications (SPA)
- Google Sheets API calls work from deployed site
- All assets must be properly referenced in pubspec.yaml
- Images should be web-optimized for faster loading