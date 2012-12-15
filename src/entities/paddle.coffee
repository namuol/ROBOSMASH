ig.module(
  'game.entities.paddle'
).requires(
  'impact.entity'
).defines ->
  ACC = 40
  DEC = 0.7

  window.EntityPaddle = ig.Entity.extend
    size:
      x: 8
      y: 32
    gravityFactor: 0
    maxVel:
      x: 0
      y: 600
    collides: ig.Entity.COLLIDES.FIXED
    bounciness: 0
    animSheet: new ig.AnimationSheet 'media/paddle-a.png', 8, 32
    init: (x,y, settings) ->
      @parent x,y, settings

      @ay = 0

      @addAnim 'idle', 1, [0]

    update: ->
      if @ay > 0
        @vel.y += ACC
      else if @ay < 0
        @vel.y -= ACC
      else
        @vel.y *= DEC
      @anims.idle.angle = (@vel.y / @maxVel.y) * -0.1
      if @pos.x > 128
        @anims.idle.angle *= -1
      @parent()
