ig.module(
  'game.entities.head'
).requires(
  'impact.entity'
).defines ->
  MIN_SPD = 50
  SPD = 30
  MAX_SPD = 10

  window.EntityHead = ig.Entity.extend
    size:
      x: 32
      y: 16
    zIndex: 20
    animSheet: new ig.AnimationSheet 'media/gfx.png', 64, 32
    init: (x,y, settings) ->
      @addAnim 'head', 5, [1], true
      @addAnim 'jaw', 5, [3], true
      @plant =
        x:x
        y:y+50

      @parent x,y, settings
    update: ->
      @vel.x += ((@plant.x - @pos.x) - @vel.x) * 0.25
      @vel.y += ((@plant.y - @pos.y) - @vel.y) * 0.25
      spd = Math.sqrt(@vel.x*@vel.x + @vel.y*@vel.y)
      if spd > MAX_SPD
        @vel.x /= spd
        @vel.y /= spd
        @vel.x *= MAX_SPD
        @vel.y *= MAX_SPD

      #@parent arguments...
      @pos.x += @vel.x
      @pos.y += @vel.y

      if @plant.y > 320
        console.log 'THATS IT'

    draw: ->
      px = @pos.x - ig.game.screen.x
      py = @pos.y + 2*Math.sin(ig.game.time/150) - ig.game.screen.y
      @anims.jaw.draw px, 4 + py + 3*Math.sin(ig.game.time/250)
      @anims.head.draw px, py
