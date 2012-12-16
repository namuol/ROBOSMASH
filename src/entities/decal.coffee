ig.module(
  'game.entities.decal'
).requires(
  'impact.entity'
).defines ->
  ROW_COUNT = 1
  EPSILON = 1

  window.EntityDecal = ig.Entity.extend
    zIndex: -1
    size:
      x:32
      y:32
    animSheet: new ig.AnimationSheet 'media/large_decals.png', 32,32
    init: (x,y, settings) ->
      @addAnim 'impact0', 5, [0], true
      @parent arguments...

      @currentAnim = @anims[@anim]
      @currentAnim.flip.x = @flipx or false
      @currentAnim.flip.x = @flipy or false

    update: ->
      if @pos.y + @size.y < ig.game.screen.y
        @kill()
