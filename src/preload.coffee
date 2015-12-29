electron      = require 'electron'

ipc           = electron.ipcRenderer

ipc.on 'player', (message) ->
  player = window.AlpacAudio.player
  switch message
    when 'stop' then player.stop()
    when 'playpause' then player.play_pause()
    when 'previous' then player.previous_track()
    when 'next' then player.next_track()

ipc.on 'volume', (message) ->
  player = window.AlpacAudio.player
  switch message
    when 'up' then player.adjust_volume(5)
    when 'down' then player.adjust_volume(-5)
    when 'mute' then player.toggle_mute()
