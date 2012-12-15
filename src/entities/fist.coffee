ig.module(
  'game.entities.fist'
).requires(
  'impact.entity'
).defines ->

  STICKY_DURATION = 30
  MAX_SPD = 32

  window.EntityFist = ig.Entity.extend
    size:
      x: 16
      y: 16
    startx: 10
    starty: 16
    velx: 0
    vely: 0
    animSheet: new ig.AnimationSheet 'media/gfx.png', 16, 16
    init: ->
      @addAnim 'idle', 5, [8], true
      @parent arguments...

    update: ->
      if ig.input.pressed 'punch'
       @stickX = ig.input.mouse.x
       @stickY = ig.input.mouse.y
       @released = 0
       @punching = true

      if not @punching
        @pos.x = @startx
        @pos.y = @starty
      else
        if ++@released >= STICKY_DURATION
          @punching = false
        @velx += ((@stickX - @pos.x) - @velx) * 0.5
        @vely += ((@stickY - @pos.y) - @vely) * 0.5

      @pos.x += @velx
      @pos.y += @vely

      @parent arguments...
