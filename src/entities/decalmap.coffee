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
        ++i

    update: ->
      @parent arguments...
