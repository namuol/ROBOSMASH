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
    velx: 0
    vely: 0
    animSheet: new ig.AnimationSheet 'media/gfx.png', 16, 16
    decals: new ig.AnimationSheet 'media/large_decals.png', 32, 32
    zIndex: 20
    released: -1
    posx: 0
    posy: 0
    init: (x,y, settings) ->
      @parent arguments...

      @addAnim 'idle', 5, [8], true
      @startx = x
      @starty = y

    spawnImpacts: ->
      dx = @posx - @prevx
      dy = @posy - @prevy
      d = Math.sqrt(dx*dx + dy*dy)
      count = Math.ceil(d / RADIUS)
      dx = dx / count
      dy = dy / count
      i = 0
      while i < count
        _dy = @prevy+i*dy
        if _dy <= @stickY
          ig.game.spawnEntity 'EntityImpact', @prevx+i*dx, _dy,
            fist: @
        ++i

    update: ->
      @prevx = @posx
      @prevy = @posy

      if @released < 0 and ig.input.pressed @button
       @stickX = @crosshair.pos.x - 8
       @stickY = @crosshair.pos.y - 8
       @released = 0
       @punching = true

      if not @punching
        @posx = @startx + ig.game.screen.x
        @posy = @starty + ig.game.screen.y
      else
        if ++@released >= STICKY_DURATION
          @released = -1
          @punching = false
        @velx += ((@stickX - @posx) - @velx) * 0.5
        @vely += ((@stickY - @posy) - @vely) * 0.5

      @posx += @velx
      @posy += @vely

      if false and @posy > @stickY
        @pos.x = @stickX
        @pos.y = @stickY
      else
        @pos.x = @posx
        @pos.y = @posy

      if @punching
        @spawnImpacts()

      @parent arguments...
