ig.module(
  'game.entities.debris'
).requires(
  'impact.entity'
).defines ->
  MIN_SPD = 8

  window.EntityDebris = ig.Entity.extend
    size:
      x:4
      y:4
    maxVel:
      x:9999
      y:9999
    zIndex: 25
    animSheet: new ig.AnimationSheet 'media/debris.png', 4,4
    gravity: 50
    init: (x,y, settings) ->
      @addAnim 'coal', 0.1, [0,1,2,3,4,5]

      @parent arguments...

      if typeof @anim != 'string'
        @currentAnim = @anim
      else
        @currentAnim = @anims[@anim]
      
      @startTTL = @ttl
      @bottom = y

    update: ->
      @parent arguments...
      
      if --@ttl < 0
        @kill()

      @currentAnim.alpha = @ttl / @startTTL
      if @pos.y + @size.y < ig.game.screen.y
        @kill()

      if @pos.y > @bottom
        @pos.y = @bottom
        @vel.y *= -0.8

      if Math.abs(@pos.y - @bottom) <= 2
        @vel.x *= 0.8

      if Math.abs(@vel.y) < MIN_SPD
        @vel.y = 0
      if Math.abs(@vel.x) < MIN_SPD
        @vel.x = 0
