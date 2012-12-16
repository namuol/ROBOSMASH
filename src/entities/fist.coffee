ig.module(
  'game.entities.fist'
).requires(
  'impact.entity'
  'game.entities.impact'
  'game.entities.decal'
).defines ->

  STICKY_DURATION = 80
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
      punched = false

      for p in @punch
        if ig.input.pressed p
          punched = true
          break

      if @released < 0 and punched
        @stickX = @crosshair.pos.x - 8
        @stickY = @crosshair.pos.y - 8
        @released = 0
        @punching = true
        @decald = false

      if not @punching
        @velx = ((@startx + @head.pos.x) - @posx) * 0.15
        @vely = ((@starty + @head.pos.y) - @posy) * 0.15
        @released = -1
      else
        if ++@released >= STICKY_DURATION
          @punching = false
        @velx += ((@stickX - @posx) - @velx) * 0.5
        @vely += ((@stickY - @posy) - @vely) * 0.5

      @posx += @velx
      @posy += @vely

      if @punching and @posy > @stickY
        @pos.x = @stickX
        @pos.y = @stickY
        if not @decald
          @head.plant.x = @pos.x - @startx
          @head.plant.y = @pos.y - @starty

          ig.game.spawnEntity 'EntityDecal', @pos.x-8, @pos.y,
            anim: 'impact0'
            flipx: Math.random() < 0.5
            flipy: Math.random() < 0.5
          ig.game.sortEntitiesDeferred()
          @decald = true
          ig.game.shake 2, 10
      else
        @pos.x = @posx
        @pos.y = @posy

      if @punching
        @spawnImpacts()

      @parent arguments...
