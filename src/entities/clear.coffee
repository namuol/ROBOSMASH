ig.module(
  'game.entities.clear'
).requires(
  'impact.entity'
).defines ->
  SPD = 25

  window.EntityClear = ig.Entity.extend
    gravityFactor: 0
    zIndex: 28
    check: new ig.Sound 'media/sounds/check.*'
    ttl: 60
    init: ->
      @check.volume = 1
      @check.play()
      for e in ig.game.getEntitiesByType 'EntityHurry'
        e.kill()

    update: ->
      @parent arguments...
      if --@ttl < 0
        @kill()

    draw: ->
     ig.game.font.draw 'CHECKPOINT!!!', 50,95
