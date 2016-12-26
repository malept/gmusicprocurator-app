electron       = require 'electron'

globalShortcut = electron.globalShortcut

main_window = null

electron.app.on 'window-all-closed', ->
  electron.app.quit() unless process.platform is 'darwin'

electron.app.on 'ready', ->
  main_window = new electron.BrowserWindow
    icon: "#{__dirname}/icon-48.png"
    show: false
    width: 1280
    height: 720
    webPreferences:
      nodeIntegration: false
      preload: "#{__dirname}/preload.js"

  main_window.on 'ready-to-show', ->
    main_window.show()
    if process.env.hasOwnProperty('GMP_DEV_TOOLS')
      main_window.openDevTools(detach: true)

  main_window.loadURL('http://localhost:5000/')

  # Media keys
  globalShortcut.register 'VolumeUp', ->
    main_window.webContents.send 'volume', 'up'
  globalShortcut.register 'VolumeDown', ->
    main_window.webContents.send 'volume', 'down'
  globalShortcut.register 'VolumeMute', ->
    main_window.webContents.send 'volume', 'mute'
  globalShortcut.register 'MediaStop', ->
    main_window.webContents.send 'player', 'stop'
  globalShortcut.register 'MediaPlayPause', ->
    main_window.webContents.send 'player', 'playpause'
  globalShortcut.register 'MediaPreviousTrack', ->
    main_window.webContents.send 'player', 'previous'
  globalShortcut.register 'MediaNextTrack', ->
    main_window.webContents.send 'player', 'next'

  main_window.on 'closed', ->
    globalShortcut.unregisterAll()
    main_window = null
