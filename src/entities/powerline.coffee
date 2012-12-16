ig.module(
  'game.entities.powerline'
).requires(
  'impact.entity'
).defines ->

  window.EntityPowerline = ig.Entity.extend
    size:
      x: 48
      y: 8
    offset:
      x: 8
      y: 12
    zIndex: 20
    type: ig.Entity.TYPE.B
    checkAgainst: ig.Entity.TYPE.A
    animSheet: new ig.AnimationSheet 'media/gfx.png', 64, 32
    init: (x,y, settings) ->
      @parent x,y, settings
      @addAnim 'idle', 5, [2], true
      @addAnim 'broken', 5, [4], true
      if @flipx
        for own k,a of @anims
          a.flip.x = true


    check: (other) ->
      return if other.head
      if @currentAnim != @anims.broken
        @currentAnim = @anims.broken
        other.pos.y -= other.pos.y - @pos.y
        ig.game.head.hit 60
        ig.game.shake 60, 0
