ig.module(
  'game.entities.fist'
).requires(
  'impact.entity'
  'game.entities.impact'
).defines ->

  STICKY_DURATION = 30
  MAX_SPD = 32
  RADIUS = 16

  window.EntityFist = ig.Entity.extend
    _wmIgnore: true
    size:
      x: 16
      y: 16
    startx: 10
    starty: 16
    velx: 0
    vely: 0
    animSheet: new ig.AnimationSheet 'media/gfx.png', 16, 16
    zIndex: 20
    released: -1
    init: ->
      @addAnim 'idle', 5, [8], true
      @parent arguments...

    spawnImpacts: ->
      dx = @pos.x - @prevx
      dy = @pos.y - @prevy
      d = Math.sqrt(dx*dx + dy*dy)
      count = Math.ceil(d / RADIUS)
      dx = dx / count
      dy = dy / count
      i = 0
      while i < count
        ig.game.spawnEntity 'EntityImpact', @prevx+i*dx, @prevy+i*dy,
          fist: @
        ++i

    update: ->
      @prevx = @pos.x
      @prevy = @pos.y

      if @released < 0 and ig.input.pressed 'punch'
       @stickX = ig.input.mouse.x - 8
       @stickY = ig.input.mouse.y + 8
       @released = 0
       @punching = true

      if not @punching
        @pos.x = @startx
        @pos.y = @starty
      else
        if ++@released >= STICKY_DURATION
          @released = -1
          @punching = false
        @velx += ((@stickX - @pos.x) - @velx) * 0.5
        @vely += ((@stickY - @pos.y) - @vely) * 0.5

      @pos.x += @velx
      @pos.y += @vely

      if @punching
        @spawnImpacts()

      @parent arguments...
