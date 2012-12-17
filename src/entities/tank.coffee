ig.module(
  'game.entities.tank'
).requires(
  'game.entities.vehicle'
).defines ->
  MIN_SPD = 50
  SPD = 30

  window.EntityTank = window.EntityVehicle.extend
    size:
      x: 24
      y: 16
    score: 1500
    animSheet: new ig.AnimationSheet 'media/tank.png', 24,16
    fired: false
    vehicle: false

    init: (x,y, settings) ->
      @parent x,y, settings

      @addAnim 'go', 0.05, [0,1]
      @currentAnim = @anims.go
      @vel.x *= 0.25

    fireIn:0
    fire: ->
      @fired = true
      ig.game.spawnEntity 'EntityBullet', @pos.x, @pos.y

    update: ->
      @parent arguments...
      
      dx = @pos.x - ig.game.head.pos.x
      dy = @pos.y - ig.game.screen.y

      if !@fired and @fireIn < 0 and dy < ig.system.height and (dx > 0) and (dx < ig.game.head.size.x)
        @fireIn = 10

      if --@fireIn is 0
        @fire()


