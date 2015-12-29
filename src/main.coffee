electron        = require 'electron'

app             = electron.app
BrowserWindow   = electron.BrowserWindow
global_shortcut = electron.globalShortcut
NativeImage     = require 'native-image'

main_window = null

app.on 'window-all-closed', ->
  app.quit() unless process.platform is 'darwin'

app.on 'ready', ->
  icon = NativeImage.createFromPath("#{__dirname}/icon-48.png")
  options =
    icon: icon
    width: 1280
    height: 720
    preload: "#{__dirname}/preload.js",
    'node-integration': false
  main_window = new BrowserWindow(options)

  wants_dev_tools = -> process.argv.indexOf('--dev-tools') isnt -1

  main_window.loadURL('http://localhost:5000/')
  main_window.openDevTools(detach: true) if wants_dev_tools()

  # Media keys
  global_shortcut.register 'VolumeUp', ->
    main_window.webContents.send 'volume', 'up'
  global_shortcut.register 'VolumeDown', ->
    main_window.webContents.send 'volume', 'down'
  global_shortcut.register 'VolumeMute', ->
    main_window.webContents.send 'volume', 'mute'
  global_shortcut.register 'MediaStop', ->
    main_window.webContents.send 'player', 'stop'
  global_shortcut.register 'MediaPlayPause', ->
    main_window.webContents.send 'player', 'playpause'
  global_shortcut.register 'MediaPreviousTrack', ->
    main_window.webContents.send 'player', 'previous'
  global_shortcut.register 'MediaNextTrack', ->
    main_window.webContents.send 'player', 'next'

  main_window.on 'closed', ->
    global_shortcut.unregisterAll()
    main_window = null
