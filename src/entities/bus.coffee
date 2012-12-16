ig.module(
  'game.entities.bus'
).requires(
  'game.entities.vehicle'
).defines ->
  MIN_SPD = 50
  SPD = 30

  window.EntityBus = window.EntityVehicle.extend
    size:
      x: 32
      y: 16
    mass: 200
    animSheet: new ig.AnimationSheet 'media/vehicles.png', 32, 13
    init: (x,y, settings) ->
      @addAnim 'go', 0.05, [4,5]
      @currentAnim = @anims.go

      @parent x,y, settings
