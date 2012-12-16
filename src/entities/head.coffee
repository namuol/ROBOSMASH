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
      x: 64
      y: 32
    zIndex: 20
    head: true
    type: ig.Entity.TYPE.A
    checkAgainst: ig.Entity.TYPE.NONE
    animSheet: new ig.AnimationSheet 'media/gfx.png', 64, 32
    hit: (stall) ->
      @stall = stall

    init: (x,y, settings) ->
      @addAnim 'head', 5, [1], true
      @addAnim 'jaw', 5, [3], true
      @plant =
        x:x
        y:y+50

      @parent x,y, settings
    update: ->
      if @stall > 0
        --@stall
        return

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
      if @stall > 0
        if @stall % 10 < 5
          @currentAnim.alpha = 0.5
          @anims.jaw.alpha = 0.5
        else
          @currentAnim.alpha = 1
          @anims.jaw.alpha = 1
      else
        @anims.jaw.alpha = 1
        @currentAnim.alpha = 1
      px = @pos.x - ig.game.screen.x
      py = @pos.y + 2*Math.sin(ig.game.time/150) - ig.game.screen.y
      @anims.jaw.draw px, 4 + py + 3*Math.sin(ig.game.time/250)
      @anims.head.draw px, py
