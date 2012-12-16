ig.module(
  'game.entities.carspawner'
).requires(
  'impact.entity'
).defines ->
  MIN_DELAY = 30
  DELAY = 30

  TYPES = [
    'car'
    'car'
    'car'
    'car'
    'car'
    'car'
    'car'
    'car'
    'car'
    'truck'
    'truck'
    'truck'
    'truck'
    'truck'
    'bus'
    'bus'
    'bus'
    'firetruck'
  ]

  window.EntityCarspawner = ig.Entity.extend
    size:
      x: 150
      y: 32
    nextCar: MIN_DELAY + DELAY
    update: ->
      return if @pos.y > ig.game.screen.y + ig.system.height

      if @pos.y + @size.y < ig.game.screen.y
        @kill()

      if --@nextCar < 0
        type = choose TYPES
        left = Math.random() < 0.5

        py = @pos.y
        if left
          px = -32
          py += 12
        else
          px = @size.x

        switch choose TYPES
          when 'car'
            ig.game.spawnEntity 'EntityVehicle', px, py, {}
          when 'truck'
            ig.game.spawnEntity 'EntityVehicle', px, py, {}
          when 'bus'
            ig.game.spawnEntity 'EntityBus', px, py, {}
          when 'firetruck'
            ig.game.spawnEntity 'EntityFiretruck', px, py, {}
        ig.game.sortEntitiesDeferred()
        @nextCar = MIN_DELAY + Math.random()*DELAY
