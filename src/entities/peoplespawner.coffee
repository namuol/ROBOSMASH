ig.module(
  'game.entities.peoplespawner'
).requires(
  'impact.entity'
).defines ->
  MIN_DELAY = 30
  DELAY = 30
  RATE = 1/64

  window.EntityPeoplespawner = ig.Entity.extend
    size:
      x: 32
      y: 32
    init: ->
      @parent arguments...
      return if window.wm
      area = @size.x * @size.y
      i=0
      console.log area
      while i < area * RATE
        if Math.random() < 0.5
          px = @pos.x + Math.random() * @size.x
          py = @pos.y + Math.random() * @size.y
          ig.game.spawnEntity 'EntityPerson', px,py, {}
        ++i

    _wmScalable:true
    update: ->
      @kill()
      @parent arguments...
