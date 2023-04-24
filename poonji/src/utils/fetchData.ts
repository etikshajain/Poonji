import { google } from 'googleapis';

async function fetchData(sheetId: string) {
  const auth = new google.auth.GoogleAuth({
    keyFile: 'credentials.json',
    scopes: 'https://www.googleapis.com/auth/spreadsheets',
  });

  const client = await auth.getClient();
  const googleSheet = google.sheets({ version: 'v4', auth: client });

  const request = {
    auth: auth,
    spreadsheetId: sheetId,
    includeGridData: true, // TODO: Use Field Mask
  };

  let getMetaData = await googleSheet.spreadsheets.get(request);

  return getMetaData.data['sheets'][0]['data'];
}

async function fetchValid(sheetId: string, sheetColumn: number) {
  const response = await fetchData(sheetId);
  const rows = response[0].rowData;
  return rows.map((r) =>
    r.values[sheetColumn].formattedValue.trim().toLowerCase(),
  );
}

export { fetchValid };
