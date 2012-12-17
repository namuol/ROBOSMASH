ig.module(
  'game.entities.splat'
).requires(
  'impact.entity'
).defines ->

  window.EntitySplat = ig.Entity.extend
    zIndex: -1
    size:
      x:16
      y:16
    animSheet: new ig.AnimationSheet 'media/splats.png', 16,16
    ttl: 150
    init: (x,y, settings) ->
      @addAnim '_0', 5, [0], true
      @addAnim '_1', 5, [1], true
      @addAnim '_2', 5, [2], true

      @parent arguments...
      
      num = Math.floor(Math.random() * 3)
      @currentAnim = @anims['_'+num]
      @currentAnim.flip.x = Math.random() < 0.5

    update: ->
      if --@ttl < 0
        @kill()

      if @ttl < 60
        @currentAnim.alpha = @ttl / 100

      if @pos.y + @size.y < ig.game.screen.y
        @kill()
