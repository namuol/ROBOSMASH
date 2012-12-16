ig.module(
  'game.entities.crosshair'
).requires(
  'impact.entity'
).defines ->

  window.EntityCrosshair = ig.Entity.extend
    size:
      x: 5
      y: 5
    animSheet: new ig.AnimationSheet 'media/gfx.png', 16, 16
    init: ->
      @parent arguments...
      @addAnim 'idle', 5, [0], true

    update: ->
      @pos.x = ig.input.mouse.x + ig.game.screen.x + @ox
      @pos.y = ig.input.mouse.y + ig.game.screen.y + @oy

    draw: ->
      sx = @pos.x - ig.game.screen.x
      sy = @pos.y - ig.game.screen.y
      @currentAnim.draw sx, sy
