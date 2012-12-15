ig.module(
  'game.entities.crosshair'
).requires(
  'impact.entity'
).defines ->

  window.EntityCrosshair = ig.Entity.extend
    size:
      x: 5
      y: 5
    offset:
      x:3
      y:-12
    animSheet: new ig.AnimationSheet 'media/gfx.png', 16, 16
    init: ->
      @addAnim 'idle', 5, [0], true

    update: ->
      @pos.x = ig.input.mouse.x
      @pos.y = ig.input.mouse.y
