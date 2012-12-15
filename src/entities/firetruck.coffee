ig.module(
  'game.entities.firetruck'
).requires(
  'game.entities.vehicle'
).defines ->
  MIN_SPD = 50
  SPD = 30

  window.EntityFiretruck = window.EntityVehicle.extend
    size:
      x: 32
      y: 16
    mass: 200
    animSheet: new ig.AnimationSheet 'media/vehicles.png', 32, 16
    init: (x,y, settings) ->
      @addAnim 'go', 0.05, [6,7]
      @currentAnim = @anims.go

      @parent x,y, settings
