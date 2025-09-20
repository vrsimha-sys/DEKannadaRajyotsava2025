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

**Google Sheet URL**: https://docs.google.com/spreadsheets/d/1_PhI-Rrx6RMF45X7G1yO6lv7I22D4K1yoS1ZyUqza8I/edit

**Spreadsheet ID**: `1_PhI-Rrx6RMF45X7G1yO6lv7I22D4K1yoS1ZyUqza8I` (already configured in your app)

---

## 🔧 Step 1: Create Sheet Structure

### 1.1 Add Required Sheets
Your Google Sheet needs exactly 7 tabs. Create them by:
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

### 1.2 Add Column Headers
For each sheet, add headers in **Row 1** exactly as specified:

#### Players Sheet (Row 1):
```
player_id | name | email | phone | flat_number | category | proficiency | emergency_contact | emergency_phone | registration_date | base_price | status | team_id | created_at
```

#### Teams Sheet (Row 1):
```
team_id | team_name | captain_id | total_budget | spent_budget | remaining_budget | player_count | wins | losses | points | status | created_at
```

#### Auction_History Sheet (Row 1):
```
auction_id | player_id | team_id | bid_amount | bid_type | is_winning_bid | auction_round | bid_timestamp | auctioneer_notes
```

#### Matches Sheet (Row 1):
```
match_id | match_type | team1_id | team2_id | scheduled_date | scheduled_time | venue | status | team1_score | team2_score | winner_team_id | match_duration | referee | round_number | group_name | notes | created_at
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

### 1.3 Format Headers
1. Select Row 1 in each sheet
2. Make it **bold** (Ctrl+B)
3. Optional: Add background color for better visibility
4. Consider freezing Row 1 (View → Freeze → 1 row)

---

## 📝 Step 2: Add Sample Data

Use the sample data from `sample_tournament_data.md` to populate your sheets:

1. Open each sheet tab
2. Click on cell A2 (first data row)
3. Copy the sample data for that sheet from the sample data file
4. Paste using Ctrl+V
5. Verify data appears in correct columns

This will give you:
- 10 sample players across different categories
- 4 tournament teams with realistic budgets
- 7 matches in various stages
- Live match updates and commentary
- Tournament statistics and configuration

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

// Tournament Configuration
await GoogleSheetsService().getTournamentConfig(); // All settings
```

---

## 🔐 Step 4: Authentication Setup (Optional)

For production use, you'll need to set up Google Sheets API authentication:

### 4.1 Create Service Account
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing one
3. Enable Google Sheets API
4. Create a Service Account
5. Download the JSON credentials file

### 4.2 Share Your Sheet
1. Open your Google Sheet
2. Click "Share" in the top right
3. Add the service account email (from JSON file)
4. Give "Editor" permissions

### 4.3 Update Flutter App
Replace the placeholder credentials in `google_sheets_service.dart`:

```dart
final credentials = ServiceAccountCredentials.fromJson({
  // Paste your actual service account JSON here
});
```

**Note**: Currently, the app uses dummy data when authentication fails, so it works immediately for testing.

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
- Check that player categories are correctly separated
- Verify team information shows budgets and player counts
- Confirm matches appear with proper statuses
- Test refresh buttons to ensure data updates

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
1. Check the sample data format in `sample_tournament_data.md`
2. Verify your sheet structure matches `badminton_tournament_data_model.md`
3. Review the Google Sheets service implementation
4. Test with dummy data first before adding authentication

Your badminton tournament app is now ready for action! 🏸🏆