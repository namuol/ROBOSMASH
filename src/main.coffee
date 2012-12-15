ig.module(
  'game.main'
).requires(
  'impact.game',
  'impact.font',

  'game.entities.paddle-cpu',
  'game.entities.paddle-player',
  'game.entities.puck',

  'game.levels.main'

).defines ->
  MyGame = ig.Game.extend
    font: new ig.Font('media/04b03.font.png')
    init: ->
      # Initialize your game here; bind keys etc.
      ig.input.bind ig.KEY.W, 'p1up'
      ig.input.bind ig.KEY.S, 'p1down'

      ig.input.bind ig.KEY.UP_ARROW, 'p2up'
      ig.input.bind ig.KEY.DOWN_ARROW, 'p2down'

      @loadLevel LevelMain
      ig.input.initMouse()

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
  ig.main '#canvas', MyGame, 30, 256, 160, 3
