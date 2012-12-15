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
      ig.input.bind ig.KEY.Z, 'punch'
      ig.input.bind ig.KEY.C, 'grasp'

      ig.input.initMouse()
      @spawnEntity 'EntityFist', 0,0, {}
      @spawnEntity 'EntityCrosshair', 0,0, {}

    update: ->
      # Update all entities and backgroundMaps
      @parent()

      # Add your own, additional update code here
      @screen =
        x: 0
        y: 16

      ###
      if Math.floor(Math.random() * 100) < 5
        @spawnEntity 'EntityPerson', Math.random()*150, Math.random()*200, {}

      if Math.floor(Math.random() * 100) < 1
        @spawnEntity 'EntityVehicle', -17, Math.random()*200, {}
      ###

      if Math.floor(Math.random() * 100) < 5
        @spawnEntity 'EntityFiretruck', -17, Math.random()*200, {}

    draw: ->
      # Draw all entities and backgroundMaps
      @parent()
      
      # Add your own drawing code here
 
  ig.System.drawMode = ig.System.DRAW.AUTHENTIC
  ig.main '#canvas', MyGame, 60, 150, 200, 3
