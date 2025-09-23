## Teams Data Fetching Debug Guide

### Current State
The app is showing "Auction Day Awaits" because no team data is being fetched from Google Sheets.

### Debug Steps

1. **Run the Flutter app:**
   ```bash
   cd C:\WebAppProjects\DEKannadaRajyotsava\flutter_web
   flutter run -d web-server --web-port=8080
   ```

2. **Open the Team Formation page** and click the **"Debug: Test Sheets Connection"** button.

3. **Check the console output** for detailed information about:
   - Google Sheets connection status
   - Teams sheet data structure
   - Any authentication or GID issues

### Common Issues & Solutions

#### Issue 1: Wrong Teams Sheet GID
**Current GID:** `1733072859`

**How to find correct GID:**
1. Open your Google Sheets document
2. Click on the "Teams" sheet tab at the bottom
3. Look at the URL - it should show something like: `#gid=XXXXXXXX`
4. Copy that number and replace `1733072859` in the code

#### Issue 2: Sheet Not Public
**Symptoms:** Authentication errors or "Sign in" messages in logs

**Solution:**
1. Open your Google Sheets
2. Click "Share" button
3. Change sharing to "Anyone with the link" → "Viewer"
4. Save settings

#### Issue 3: Wrong Sheet Name
**Current:** Looking for sheet named "Teams"

**Solution:** Make sure your sheet tab is exactly named "Teams" (case-sensitive)

#### Issue 4: Empty Teams Sheet
**Solution:** Make sure your Teams sheet has:
- Header row with column names
- At least one data row with team information

### Expected Teams Sheet Structure
```
team_id | team_name | captain_id | total_budget | spent_budget | remaining_budget | player_count | wins | losses | points | status | created_at
T001    | Eagles    | P001       | 50000        | 25000        | 25000            | 8            | 0    | 0      | 0      | Active | 2025-01-01
```

### Next Steps
1. Run the debug test
2. Share the console output
3. Verify/fix the Teams sheet GID if needed
4. Ensure the sheet has proper data structure