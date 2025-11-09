# 🏸 Complete Google Sheets Setup Guide for Badminton Tournament App

## 📋 Overview

This guide will help you set up a complete Google Sheets backend for your DE Karnataka Rajyotsava Badminton Tournament application. The system uses Google Sheets as a database to store players, teams, matches, and tournament data.

## 🎯 What You'll Achieve

- ✅ Complete tournament data management system
- ✅ Real-time data sync between app and Google Sheets
- ✅ Player roster with categories (Men, Women, Kids)
- ✅ Team formation with auction history
- ✅ Match scheduling and live updates
- ✅ Tournament statistics and configuration
- ✅ Responsive frontend that adapts to data changes

## 📊 Your Google Sheet Information

**Google Sheet URL**: https://docs.google.com/spreadsheets/d/1gVCjlH1lVb-OzLESEwZPUCbyKdQeuN0hKsyvmTV7-TU/edit

**Spreadsheet ID**: `1gVCjlH1lVb-OzLESEwZPUCbyKdQeuN0hKsyvmTV7-TU` (already configured in your app)

---

## 🔧 Step 1: Create Sheet Structure

### 1.1 Add Required Sheets
Your Google Sheet needs exactly 8 tabs. Create them by:
1. Right-clicking on existing sheet tabs at the bottom
2. Select "Insert sheet"
3. Create these tabs with **exact names**:

- `Players`
- `Teams`  
- `Auction_History`
- `Matches`
- `Live_Updates`
- `Tournament_Stats`
- `Tournament_Config`
- `Umpires`

### 1.2 Add Column Headers
For each sheet, add headers in **Row 1** exactly as specified:

#### Players Sheet (Row 1):
```
player_id | name | email | phone | flat_number | category | proficiency | emergency_contact | emergency_phone | registration_date | base_price | status | team_id | created_at | photo_url
```

#### Teams Sheet (Row 1):
```
team_id | team_name | captain_id | total_budget | spent_budget | remaining_budget | player_count | wins | losses | points | status | created_at | required_number_of_adv | number_of_adv_bought | base_price_per_adv | total_base_price_adv | required_number_of_int_plus | number_of_int_plus_bought | base_price_per_int_plus | total_base_price_int_plus | required_number_of_int | number_of_int_bought | base_price_per_int | total_base_price_int | required_number_of_beg | number_of_beg_bought | base_price_per_beg | total_base_price_beg | total_base_pool | owner | owner_flat | captain_flat
```

#### Auction_History Sheet (Row 1):
```
auction_id | player_id | team_id | initial_bid_amount | bid_amount | bid_type | is_winning_bid | auction_round | bid_timestamp | auctioneer_notes
```

#### Matches Sheet (Row 1):
```
Time | Court | Pair 1 | Pair 2 | Category | Skill | Team 1 | Team 2 | Status | Team1_Score | Team2_Score | Winner_Team_ID
```

#### Live_Updates Sheet (Row 1):
```
update_id | match_id | update_type | team1_current_score | team2_current_score | game_set | event_description | timestamp | is_active
```

#### Tournament_Stats Sheet (Row 1):
```
stat_id | entity_type | entity_id | stat_category | stat_name | stat_value | calculation_date | notes
```

#### Tournament_Config Sheet (Row 1):
```
config_key | config_value | config_type | description | is_active | last_updated
```

#### Umpires Sheet (Row 1):
```
user_name | password
```

### 1.3 Format Headers
1. Select Row 1 in each sheet
2. Make it **bold** (Ctrl+B)
3. Optional: Add background color for better visibility
4. Consider freezing Row 1 (View → Freeze → 1 row)

### 1.4 Verify Sheet GIDs
Each sheet has a unique GID that the app uses to fetch data. The app is currently configured with these GIDs:

- `Players`: GID `0` (usually the first sheet)
- `Teams`: GID `1291526164`
- `Auction_History`: GID `1603832257`
- `Matches`: GID `424738768`
- `Live_Updates`: GID `467423031`
- `Tournament_Stats`: GID `1466958466`
- `Tournament_Config`: GID `780447557`
- `Umpires`: GID `PLACEHOLDER_GID` (Replace with actual GID from your sheet)

**To find your sheet's GID:**
1. Click on a sheet tab
2. Look at the URL in your browser
3. Find `#gid=XXXXXXXX` - that number is your GID

**If your GIDs are different**, update them in `flutter_web/lib/services/google_sheets_service.dart` in the `_sheetGids` map.

### 1.5 Make Sheet Public (Required)
The app uses CSV export to read data, so your sheet must be public:

1. Click **"Share"** button in top-right corner of your Google Sheet
2. Click **"Change to anyone with the link"**
3. Set permission to **"Viewer"** 
4. Click **"Done"**

⚠️ **Important**: Without this step, the app cannot access your sheet data!

---

## 📝 Step 2: Add Sample Data

Add sample data to test your setup. Start entering data from **Row 2** (Row 1 contains headers):

### 2.1 Sample Players Data (add to Players sheet):
```
P001 | Rajesh Kumar | rajesh@email.com | +91-9876543210 | 4B | Men | Advanced | Sunita Kumar | +91-9876543211 | 2025-09-15 | 5000 | Active | T001 | 2025-09-15 10:30:00 | 
P002 | Priya Sharma | priya@email.com | +91-9876543212 | 7A | Women | Intermediate+ | Amit Sharma | +91-9876543213 | 2025-09-15 | 4000 | Active | T002 | 2025-09-15 11:00:00 | 
P003 | Arjun Patel | arjun@email.com | +91-9876543214 | 2C | Kids | Beginner | Kavita Patel | +91-9876543215 | 2025-09-16 | 2000 | Active | | 2025-09-16 09:00:00 | 
```

### 2.2 Sample Teams Data (add to Teams sheet):
```
T001 | Eagles | P001 | 50000 | 25000 | 25000 | 8 | 0 | 0 | 0 | Active | 2025-01-01 | 2 | 1 | 5000 | 5000 | 2 | 1 | 4000 | 4000 | 2 | 1 | 3000 | 3000 | 2 | 1 | 2000 | 2000 | 14000 | Rajesh Kumar | 4B | 4B
T002 | Tigers | P002 | 50000 | 30000 | 20000 | 6 | 0 | 0 | 0 | Active | 2025-01-01 | 2 | 1 | 5000 | 5000 | 2 | 1 | 4000 | 4000 | 2 | 1 | 3000 | 3000 | 2 | 1 | 2000 | 2000 | 14000 | Priya Sharma | 7A | 7A
```

### 2.3 Sample Matches Data (add to Matches sheet):
```
M001 | Pool Match | T001 | T002 | 2025-11-15 | 10:00 AM | Court 1 | Scheduled | 0 | 0 | | | Referee 1 | 1 | Group A | Opening match | 2025-11-01
M002 | Semi Final | T001 | T002 | 2025-11-16 | 2:00 PM | Court 1 | Live | 15 | 12 | | 45 mins | Referee 2 | 2 | Semi Finals | Exciting match | 2025-11-01
```

This will give you:
- Sample players across different categories (Men, Women, Kids)
- Tournament teams with realistic budgets and player requirements
- Matches in various stages (Scheduled, Live, Completed)
- Proper data structure for testing the app functionality

---

## ⚙️ Step 3: Configure Flutter App

### 3.1 Verify Google Sheets Service
Your app already has the Google Sheets service configured with the correct spreadsheet ID. The service includes:

- **Data Reading**: Methods to fetch players, teams, matches, etc.
- **Category Filtering**: Get players by category (Men/Women/Kids)
- **Status Filtering**: Get matches by status (Live/Completed/Scheduled)
- **Dummy Data Fallback**: Works even without authentication
- **Error Handling**: Graceful degradation when sheets are unavailable

### 3.2 Available Data Methods

Your Flutter app can now use these methods:

```dart
// Players
await GoogleSheetsService().getPlayers(); // All players
await GoogleSheetsService().getPlayers(category: 'Men'); // Men only

// Teams  
await GoogleSheetsService().getTeams(); // All teams

// Matches
await GoogleSheetsService().getMatches(); // All matches
await GoogleSheetsService().getMatches(status: 'Live'); // Live matches only

// Umpires
await GoogleSheetsService().getUmpires(); // All umpires
await GoogleSheetsService().getAvailableUmpires(); // Available umpires only

// Tournament Configuration
await GoogleSheetsService().getTournamentConfig(); // All settings
```

---

## 🔐 Step 4: Data Access Method

This app uses **Direct CSV Access** to read Google Sheets data, which is simpler than API authentication:

### 4.1 How It Works
- The app fetches data using Google Sheets' CSV export feature
- No API keys or service accounts needed
- Just requires the sheet to be publicly viewable (see Step 1.5)

### 4.2 Current Implementation
The `GoogleSheetsService` automatically:
- Constructs CSV export URLs using your spreadsheet ID and sheet GIDs  
- Parses the CSV data into Dart objects
- Handles errors gracefully with fallback to dummy data

### 4.3 For Advanced Users (Optional)
If you want to implement write operations or private sheets:
1. Set up Google Sheets API with service account authentication
2. Replace the CSV reading logic with proper API calls
3. Add write methods for adding/updating data directly from the app

**Note**: The current CSV method is read-only but works immediately without authentication setup.

---

## 🎮 Step 5: Test Your Setup

### 5.1 Run the Flutter App
```bash
cd flutter_web
flutter run -d chrome --web-port 8080
```

### 5.2 Navigate Through Pages
1. **Home Page**: Should display tournament welcome message
2. **Player Roster**: Should show players in Men/Women/Kids tabs
3. **Team Formation**: Should display teams with auction info
4. **Battle Day**: Should show matches in different statuses

### 5.3 Verify Data Display
- **Player Roster**: Should show players in Men/Women/Kids tabs with photos and details
- **Team Formation**: Should display teams with auction info or "Auction Day Awaits" if no teams
- **Battle Day**: Should show matches in Fixtures/Live/Results tabs or "Battle yet to Start" if no matches
- Use **"Debug: Test Sheets Connection"** button on Team Formation page for detailed diagnostics

### 5.4 Expected Behaviors
- **With Sample Data**: All pages should show your test data
- **Empty Sheets**: Pages will show placeholder messages (e.g., "Auction Day Awaits")
- **Connection Issues**: App gracefully falls back to dummy data for demonstration

---

## 📱 Step 6: Frontend Integration

### 6.1 How Data Flows
```
Google Sheets → GoogleSheetsService → Flutter Widgets → User Interface
```

### 6.2 Key Integration Points

**Player Roster Page**:
- Fetches players by category
- Displays in responsive grid
- Shows player details and status

**Team Formation Page**:
- Displays team information
- Shows auction history
- Calculates budget remaining

**Battle Day Page**:
- Lists matches by status (Fixtures/Live/Results)
- Shows live scores and updates
- Displays tournament standings

---

## 🔧 Step 7: Customization

### 7.1 Modify Tournament Settings
Edit the `Tournament_Config` sheet to change:
- Tournament name and dates
- Team budgets and limits
- Contact information
- Entry fees

### 7.2 Add More Data
- **Players**: Add rows to Players sheet with unique player_ids
- **Teams**: Create new teams with unique team_ids  
- **Matches**: Schedule additional matches with proper IDs
- **Live Updates**: Add real-time match commentary

### 7.3 Extend Functionality
The Google Sheets service can be extended to support:
- Data writing (add new players/matches)
- Real-time updates via polling
- Advanced statistics calculations
- Tournament bracket generation

---

## 🚨 Troubleshooting

### Common Issues

**App shows dummy data instead of sheet data**:
- Check that sheet names are exactly correct
- Verify data starts from Row 2 (Row 1 is headers)
- Ensure Google Sheets API authentication is set up

**Data not displaying correctly**:
- Verify column headers match exactly
- Check for empty cells or formatting issues
- Ensure dates are in YYYY-MM-DD format

**Error messages in Flutter**:
- Check browser console for detailed errors
- Verify Google Sheets service initialization
- Confirm internet connectivity

### Debug Mode
The app includes console logging for debugging:
- Open browser Developer Tools (F12)
- Check Console tab for Google Sheets service messages
- Look for "Failed to initialize" or "Error fetching" messages

---

## 🎯 Next Steps

### Immediate Actions
1. ✅ Set up all 7 sheets with correct headers
2. ✅ Add sample data to test functionality
3. ✅ Test Flutter app with your data
4. ✅ Verify all pages display information correctly

### Future Enhancements
- Set up Google Sheets API authentication for live data
- Add data entry forms for real tournament management
- Implement real-time match score updates
- Create tournament bracket visualization
- Add player statistics tracking
- Enable team management features

### Production Considerations
- Implement proper error handling for network issues
- Add data validation for user inputs
- Set up automated backups of tournament data
- Consider caching strategies for better performance
- Implement user roles and permissions

---

## 📞 Support

If you encounter any issues:

### Common Solutions:
1. **Sheet not loading data**: Verify sheet names match exactly (case-sensitive)
2. **Wrong data structure**: Ensure column headers are in Row 1 and match the specified format
3. **GID errors**: Check that your sheet GIDs match those in `google_sheets_service.dart`
4. **Network issues**: Ensure your Google Sheet is public (Anyone with link → Viewer)

### Debug Steps:
1. Open browser Developer Tools (F12) and check Console for error messages
2. Use the "Test Sheets Connection" button on the Team Formation page
3. Verify your spreadsheet URL matches the one in the service
4. Test with dummy data first before adding authentication

### Quick Fixes:
- **Teams showing "Auction Day Awaits"**: Check Teams sheet GID and data format
- **Players not loading**: Verify Players sheet has data starting from Row 2
- **Matches not displaying**: Confirm Matches sheet structure and status values

Your badminton tournament app is now ready for action! 🏸🏆

For additional support, check the `DEBUG_TEAMS_GUIDE.md` file for specific team loading issues.