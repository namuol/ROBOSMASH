ig.module(
  'game.main'
).requires(
  'impact.game'
  'impact.font'
  'game.entities.crosshair'
  'game.entities.fist'
).defines ->
  MyGame = ig.Game.extend
    font: new ig.Font('media/04b03.font.png')
    gfx: new ig.Font('media/gfx.png')
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

    draw: ->
      # Draw all entities and backgroundMaps
      @parent()
      
      # Add your own drawing code here
 
  ig.System.drawMode = ig.System.DRAW.AUTHENTIC
  ig.main '#canvas', MyGame, 60, 150, 200, 3
