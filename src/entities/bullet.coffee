ig.module(
  'game.entities.bullet'
).requires(
  'impact.entity'
).defines ->
  SPD = 25

  window.EntityBullet = ig.Entity.extend
    gravityFactor: 0
    size:
      x: 8
      y: 8
    zIndex: 27
    type: ig.Entity.TYPE.B
    checkAgainst: ig.Entity.TYPE.A
    zapped: new ig.Sound 'media/sounds/zapped.*'
    animSheet: new ig.AnimationSheet 'media/bullet.png', 8,8
    init: (x,y, settings) ->
      @parent x,y, settings
      @addAnim 'go', 0.15, [0,1]
      @vel.y = -SPD

    update: ->
      @parent arguments...

      if (@pos.y + @size.y) < ig.game.screen.y
        @kill()

    check: (other) ->
      return if !other.head

      if @currentAnim != @anims.broken
        @currentAnim = @anims.broken
        other.pos.y -= other.pos.y - @pos.y
        ig.game.head.hit 60
        ig.game.shake 60, 0
        @zapped.volume = 0.75
        @zapped.play()
