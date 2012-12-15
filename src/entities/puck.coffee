ig.module(
  'game.entities.puck'
).requires(
  'impact.entity'
).defines ->

  Z_DEC = 0.7

  window.EntityPuck = ig.Entity.extend
    size:
      x: 8
      y: 8
    maxVel:
      x: 400
      y: 300
    collides: ig.Entity.COLLIDES.ACTIVE
    bounciness: 1.0
    animSheet: new ig.AnimationSheet 'media/puck.png', 8, 8
    type: ig.Entity.TYPE.B
    checkAgainst: ig.Entity.TYPE.A
    wallSound: new ig.Sound 'media/sounds/wall.*'
    paddleSound: new ig.Sound 'media/sounds/paddle.*'
    reset: (left=false) ->
      @pos =
        x: @startX
        y: @startY

      vx = 100
      if left
        vx *= -1
      @zn = Math.random() * 0.25

      @vel =
        x: vx
        y: -100

    init: (x,y, settings) ->
      @z = 0
      @addAnim 'idle', 1, [0]

      @startX = x
      @startY = y
      @__settings = settings

      @reset()

    update: ->
      @z *= Z_DEC

      @vel.y += @z
      @anims.idle.angle += @zn
      @parent()
    handleMovementTrace: (res) ->
      if res.collision.y
        @wallSound.play()
      @parent arguments...

    collideWith: (other, axis) ->
      if axis is 'x' and (other instanceof EntityPaddle)
        @paddleSound.play()
        @z = other.vel.y * -0.15
        @zn = other.vel.y / 300  # For spinning the ball.
        if @vel.x > 0
          @zn *= -1
        @vel.x *= 1.2
