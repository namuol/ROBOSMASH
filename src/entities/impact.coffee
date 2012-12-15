ig.module(
  'game.entities.impact'
).requires(
  'impact.entity'
).defines ->
  window.EntityImpact = ig.Entity.extend
    _wmIgnore: true
    type: ig.Entity.TYPE.A
    checkAgainst: ig.Entity.TYPE.B
    collides: ig.Entity.COLLIDES.NONE
    maxTicks: 1
    size:
      x: 16
      y: 16
    zIndex: 19
    animSheet: new ig.AnimationSheet 'media/gfx.png', 16, 16
    init: ->
      @addAnim 'idle', 5, [9], true
      @parent arguments...
    ticked: 0
    update: ->
      if @ticked > @maxTicks
        @kill()

      ++@ticked

      @parent arguments...
