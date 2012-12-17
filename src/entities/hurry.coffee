ig.module(
  'game.entities.hurry'
).requires(
  'impact.entity'
).defines ->
  SPD = 25

  window.EntityHurry = ig.Entity.extend
    gravityFactor: 0
    zIndex: 28
    hurry: new ig.Sound 'media/sounds/hurry.*'
    ttl: 60
    init: ->
      @hurry.volume = 0.5
      @hurry.play()

    update: ->
      @parent arguments...
      if --@ttl < 0
        @kill()

    draw: ->
     ig.game.font.draw 'HURRY UP!!!', 50,95
