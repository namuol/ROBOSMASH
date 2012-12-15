ig.module(
  'game.main'
).requires(
  'impact.game'
  'impact.font'
  'game.entities.crosshair'
  'game.entities.fist'
  'game.entities.person'
  'game.entities.vehicle'
  'game.entities.bus'
  'game.entities.firetruck'
).defines ->
  MyGame = ig.Game.extend
    font: new ig.Font('media/04b03.font.png')
    gfx: new ig.Font('media/gfx.png')
    clearColor: '#d6eca3'
    init: ->
      # Initialize your game here; bind keys etc.
      ig.input.bind ig.KEY.Z, 'punchL'
      ig.input.bind ig.KEY.C, 'punchR'

      ig.input.initMouse()
      ch = @spawnEntity 'EntityCrosshair', 0,0, {}
      @spawnEntity 'EntityFist', 0,0,
        button: 'punchL'
        crosshair: ch
      @spawnEntity 'EntityFist', 134,0,
        button: 'punchR'
        crosshair: ch
    time: Date.now()
    screen:
      x:0
      y:0
    update: ->
      # Update all entities and backgroundMaps

      @time = Date.now()
      sy = Math.sin(@time / 150)

      if sy > 0
        @screen.y += sy * 2

      if Math.floor(Math.random() * 100) < 3
        @spawnEntity 'EntityPerson', Math.random()*150, @screen.y + Math.random()*200, {}

      if Math.floor(Math.random() * 100) < 1
        @spawnEntity 'EntityVehicle', -17, @screen.y + Math.random()*200, {}

      if Math.floor(Math.random() * 100) < 0.33
        @spawnEntity 'EntityBus', -17, @screen.y + Math.random()*200, {}

      if Math.floor(Math.random() * 100) < 0.15
        @spawnEntity 'EntityFiretruck', -17, @screen.y + Math.random()*200, {}

      @parent()

    draw: ->
      # Draw all entities and backgroundMaps
      @parent()
 
  ig.System.drawMode = ig.System.DRAW.AUTHENTIC
  ig.main '#canvas', MyGame, 60, 150, 200, 3
