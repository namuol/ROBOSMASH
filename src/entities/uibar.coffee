ig.module(
  'game.entities.uibar'
).requires(
  'impact.entity'
).defines ->
  ROW_COUNT = 1
  EPSILON = 1

  window.EntityUibar = ig.Entity.extend
    _wmIgnore: true
    update: ->
      #
    draw: ->
      px = ig.system.getDrawPos @pos.x
      py = ig.system.getDrawPos @pos.y
      

      percent = @val/@max

      fw = ig.system.getDrawPos @size.x
      fh = ig.system.getDrawPos @size.y
      
      if @vertical
        w = ig.system.getDrawPos @size.x
        h = ig.system.getDrawPos @size.y * percent
      else
        w = ig.system.getDrawPos @size.x * percent
        h = ig.system.getDrawPos @size.y

      cp = 0
      for c in @colors
        if (percent >= c.percent) and (c.percent > cp)
          color = c.color
          cp = c.percent
      if !color
        color = 'white'


      ctx = ig.system.context
      fs = ctx.fillStyle
      ctx.fillStyle = '#000'
      px2 = ig.system.getDrawPos @pos.x
      py2 = ig.system.getDrawPos @pos.y
      ctx.fillRect px2-3, py2-3, fw+6, fh+6
      ctx.fillStyle = color
      ctx.fillRect px, py, w, h
      ctx.fillStyle = fs
