# Google Sheets Setup Instructions

## 🎯 Your Google Sheet Information

**Your Google Sheet URL**: https://docs.google.com/spreadsheets/d/1_PhI-Rrx6RMF45X7G1yO6lv7I22D4K1yoS1ZyUqza8I/edit?gid=0#gid=0

**Extracted Spreadsheet ID**: `1_PhI-Rrx6RMF45X7G1yO6lv7I22D4K1yoS1ZyUqza8I`

## 1. Configure Your Existing Google Sheet

Since you already have a Google Sheet created, we need to set it up with the proper structure for the application.

### Required Sheet Tabs

Your spreadsheet needs these three tabs (sheets):

1. **Events** - For storing event information
2. **Registrations** - For tracking event registrations  
3. **Cultural Programs** - For managing cultural program details

### How to Add New Sheets:
1. Right-click on the sheet tab at the bottom
2. Select "Insert sheet"
3. Name it appropriately (Events, Registrations, Cultural Programs)
4. Click "Done"

## 2. Set up the required sheet structure:

### Sheet 1: Events
**Column Headers (Row 1):**
| A | B | C | D | E | F | G | H |
|---|---|---|---|---|---|---|---|
| Title | Date | Location | Description | Category | Organizer | Contact | Created At |

**Instructions:**
1. Go to the "Events" sheet
2. In row 1, add the headers exactly as shown above
3. Format row 1 as bold (Ctrl+B) to distinguish headers

### Sheet 2: Registrations  
**Column Headers (Row 1):**
| A | B | C | D | E | F | G |
|---|---|---|---|---|---|---|
| Name | Email | Phone | Event ID | Event Title | Registration Date | Status |

**Instructions:**
1. Go to the "Registrations" sheet
2. In row 1, add the headers exactly as shown above
3. Format row 1 as bold (Ctrl+B) to distinguish headers

### Sheet 3: Cultural Programs
**Column Headers (Row 1):**
| A | B | C | D | E | F | G | H |
|---|---|---|---|---|---|---|---|
| Program Name | Type | Performer | Duration | Description | Venue | Date Time | Created At |

**Instructions:**
1. Go to the "Cultural Programs" sheet  
2. In row 1, add the headers exactly as shown above
3. Format row 1 as bold (Ctrl+B) to distinguish headers

## 3. Create Google Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing one
3. Enable Google Sheets API and Google Drive API
4. Create a Service Account:
   - Go to IAM & Admin > Service Accounts
   - Click "Create Service Account"
   - Fill in the details
   - Create and download the JSON key file
5. Share your Google Sheet with the service account email address (with Editor permissions)

## 4. Environment Configuration

1. Copy `.env.example` to `.env` in the flask_api directory
2. Update the following variables:
   - `GOOGLE_SPREADSHEET_ID=1_PhI-Rrx6RMF45X7G1yO6lv7I22D4K1yoS1ZyUqza8I`
   - `GOOGLE_SERVICE_ACCOUNT_FILE`: Path to your service account JSON file

**Example .env file:**
```env
FLASK_APP=app.py
FLASK_ENV=development
FLASK_DEBUG=True
PORT=5000

# Your Google Sheets Configuration
GOOGLE_SPREADSHEET_ID=1_PhI-Rrx6RMF45X7G1yO6lv7I22D4K1yoS1ZyUqza8I
GOOGLE_SERVICE_ACCOUNT_FILE=path/to/your/service-account-key.json

# CORS Settings
CORS_ORIGINS=http://localhost:3000,http://localhost:8080

# Logging
LOG_LEVEL=INFO
```

## 5. Sample Data

Add some sample data to test the integration. **Important:** Add this data starting from Row 2 (Row 1 contains headers).

### Events Sheet Sample Data:
**Row 2:**
```
ಸಾಂಸ್ಕೃತಿಕ ಕಾರ್ಯಕ್ರಮ | 2024-11-01 | Vidhana Soudha | Traditional cultural performances celebrating Karnataka's heritage | Cultural | Government of Karnataka | contact@karnataka.gov.in | 2024-09-20 10:00:00
```

**Row 3:**
```
ಕನ್ನಡ ಸಾಹಿತ್ಯ ಸಂಮೇಳನ | 2024-11-01 | Town Hall Bengaluru | Literary meet showcasing Kannada literature and poetry | Literature | Sahitya Akademi | sahitya@karnataka.gov.in | 2024-09-20 10:00:00
```

**Row 4:**
```
ಯಕ್ಷಗಾನ ಪ್ರದರ್ಶನ | 2024-11-01 | Palace Grounds | Traditional Yakshagana performance by renowned artists | Performance | Department of Kannada & Culture | culture@karnataka.gov.in | 2024-09-20 10:00:00
```

### Cultural Programs Sample Data:
**Row 2:**
```
Classical Dance Performance | Dance | Shantala Natya Academy | 45 mins | Traditional Bharatanatyam showcasing Karnataka themes | Main Stage | 2024-11-01 18:00 | 2024-09-20 10:00:00
```

**Row 3:**
```
Folk Music Concert | Music | Local Folk Artists | 30 mins | Traditional Karnataka folk songs and music | Amphitheater | 2024-11-01 19:00 | 2024-09-20 10:00:00
```

**Row 4:**
```
Yakshagana Performance | Theater | Traditional Troupe | 60 mins | Classical Yakshagana performance with mythological themes | Open Ground | 2024-11-01 20:00 | 2024-09-20 10:00:00
```

## 6. Quick Setup Checklist

- [ ] Access your Google Sheet: https://docs.google.com/spreadsheets/d/1_PhI-Rrx6RMF45X7G1yO6lv7I22D4K1yoS1ZyUqza8I/edit
- [ ] Create three sheets: Events, Registrations, Cultural Programs
- [ ] Add column headers to each sheet (Row 1)
- [ ] Add sample data to Events and Cultural Programs sheets
- [ ] Create Google Cloud Project and enable APIs
- [ ] Create Service Account and download JSON key
- [ ] Share your Google Sheet with service account email
- [ ] Update .env file with your spreadsheet ID
- [ ] Test the API connection

## 7. Testing the Connection

Once everything is set up, you can test the connection by:

1. Starting the Flask API: `python app.py`
2. Testing the events endpoint: `http://localhost:5000/api/events`
3. You should see your sample data returned as JSON

If you encounter any issues, check:
- Service account has Editor permissions on the sheet
- All APIs are enabled in Google Cloud Console  
- .env file has correct spreadsheet ID
- Sheet names match exactly: "Events", "Registrations", "Cultural Programs"