ig.module(
  'game.entities.gibs'
).requires(
  'impact.entity'
  'impact.image'
  'game.entities.debris'
).defines ->
  MIN_SPD = 8

  window.EntityGibs = ig.Entity.extend
    zIndex: 25
    init: (x,y, settings) ->
      @parent arguments...

      @img = document.createElement 'canvas'

      @img.width = ig.system.getDrawPos @anim.sheet.width
      @img.height = ig.system.getDrawPos @anim.sheet.height
      ctx = @img.getContext '2d'
      @anim.draw 0,0, ctx

      img = new ig.Image
      img.data = @img
      img.loaded = true
      img.width = @anim.sheet.width
      img.height = @anim.sheet.height
      @animSheet =
        width: 4
        height: 4
        image: img

      @gibs = []
      i=0
      while i < @count
        anim = @addAnim '_'+i, 5, [i], true
        g = ig.game.spawnEntity('EntityDebris',# new window.EntityDebris(
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
        @gibs.push g
        ++i

        @kill()

    ###
    update: ->
      if --@ttl < 0
        @kill()

      for g in @gibs
        g.update arguments...
    
    draw: ->
      for g in @gibs
        g.draw arguments...
    ###
