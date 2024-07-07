const { app, BrowserWindow } = require('electron');

// Creates the main window
function createWindow() {
  const win = new BrowserWindow({
    width: 800,              
    height: 600,             
    webPreferences: {
      nodeIntegration: true
    }
  });

  // Loads php file into the window
  //win.loadFile('./public/index.html');
  win.loadURL('http://localhost:10000');

}

// Calls createWindow() when the app is ready
app.whenReady().then(createWindow);

// Quits the app when all windows are closed (Windows & Linux)
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// Opens a window if none are open (macOS)
app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});