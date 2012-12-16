ig.module(
  'game.entities.gibs'
).requires(
  'impact.entity'
  'game.entities.debris'
).defines ->
  MIN_SPD = 8
  MAX_DEBRIS = 25

  window.EntityGibs = ig.Entity.extend
    zIndex: 25
    init: (x,y, settings) ->
      @parent arguments...

      @img = document.createElement 'canvas'

      @xoff = @xoff or 0
      @yoff = @yoff or 0
      @xoff = ig.system.getDrawPos(@xoff)
      @yoff = ig.system.getDrawPos(@yoff)

      @img.width = ig.system.getDrawPos(@w or @anim.sheet.width)
      @img.height = ig.system.getDrawPos(@h or @anim.sheet.height)

      ctx = @img.getContext '2d'
      @anim.draw @xoff,@yoff, ctx

      img = new ig.Image
      img.data = @img
      img.loaded = true
      img.width = @anim.sheet.width
      img.height = @anim.sheet.height
      @animSheet =
        width: 4
        height: 4
        image: img

      if ig.game.getEntitiesByType('EntityDebris').length < MAX_DEBRIS
        i=0
        while i < @count
          anim = @addAnim '_'+i, 5, [i], true
          g = ig.game.spawnEntity('EntityDebris',
            @pos.x + (-@ox + 2*@ox*Math.random()),
            @pos.y + (-@oy + 2*@oy*Math.random()),
            {
              vel:
                x:-@vx + 2*@vx*Math.random()
                y:-@vy + 2*@vy*Math.random()
              ttl: @ttl
              anim: anim
            }
          )
          ++i

      @kill()
