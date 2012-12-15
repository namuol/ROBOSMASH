ig.module(
  'game.entities.decalmap'
).requires(
  'impact.entity'
).defines ->
  window.EntityDecalmap = ig.Entity.extend
    init: (x,y, settings) ->
      @size =
        x: ig.game.width
        y: ig.game.height * 2

      @img = []
      i = 0
      while i < 2
        @img[i] = document.createElement 'canvas'
        @img[i].width = @size.x * 3
        @img[i].height = @size.y * 3
        @img[i].y = i * @size.y
        ++i

    blit: (anim, x, y) ->
      #anim.draw x, y,

    update: ->
      @parent arguments...

    draw: ->
      for img in @img
        if img.y + @size.y < ig.game.screen.y
          img.y += @size.y
        y = ig.system.getDrawPos ig.game.screen.y - img.y

        ig.system.context.drawImage img, 0, y
