ig.module(
  'game.entities.fist'
).requires(
  'impact.entity'
  'game.entities.impact'
  'game.entities.decal'
).defines ->

  HELD_DURATION = 7
  STOMP_DELAY = 10
  STICKY_DURATION = 20
  MAX_SPD = 32
  RADIUS = 16

  window.EntityFist = ig.Entity.extend
    _wmIgnore: true
    size:
      x: 16
      y: 16
    offset:
      x:8
      y:8
    velx: 0
    vely: 0
    gravityFactor: 0
    animSheet: new ig.AnimationSheet 'media/gfx.png', 32,32
    decals: new ig.AnimationSheet 'media/large_decals.png', 32, 32
    lift: new ig.Sound 'media/sounds/lift.*'
    stomp: new ig.Sound 'media/sounds/stomp.*'
    zIndex: 20
    released: -1
    stomped: true
    posx: 0
    posy: 0
    init: (x,y, settings) ->
      @parent arguments...

      @addAnim 'idle', 5, [1], true
      @startx = x
      @starty = y

    spawnImpacts: ->
      dx = @pos.x - @prevx
      dy = @pos.y - @prevy
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
      return if ig.game.over

      @prevx = @pos.x
      @prevy = @pos.y

      held = false
      for p in @punch
        if ig.input.pressed p
          #@stompDelay = STOMP_DELAY
          hit = true
        else if ig.input.state p
          held = true

      if held and @head.stall <= 0
        ++@held
        if @held == 1
          @lift.volume = 0.5
          @lift.play()
      else
        @held = 0

      #if @stompDelay >= 0
      #  --@stompDelay

      if (!@punching) and @other.stomped and (@released < 0) and (@held == HELD_DURATION) and (!@head.stall > 0)
        @stickX = @crosshair.pos.x
        @stickY = @crosshair.pos.y + 4
        @released = 0
        @punching = true
        @decald = false
        @stomped = false

      if not @punching
        @velx = ((@startx + @head.pos.x) - @pos.x) * 0.15
        @vely = ((@starty + @head.pos.y) - @pos.y) * 0.15
        @released = -1
      else
        if ++@released >= STICKY_DURATION
          @punching = false
        @velx += ((@stickX - @pos.x) - @velx) * 0.5
        @vely += ((@stickY - @pos.y) - @vely) * 0.5
      
      if not @head.stall > 0
        @pos.x += @velx
        @pos.y += @vely
      else
        @stomped = true # HACK

      if @punching and @pos.y > @stickY
        @pos.x = @stickX
        @pos.y = @stickY
        if not @decald
          @stomped = true
          @head.plant.x = @pos.x - @startx
          @head.plant.y = @pos.y - @starty

          ig.game.spawnEntity 'EntityDecal', @pos.x-8, @pos.y-4,
            anim: 'impact0'
            flipx: Math.random() < 0.5
            flipy: Math.random() < 0.5

          ig.game.spawnEntity 'EntityImpact', @pos.x, @pos.y,
            fist: @

          ig.game.sortEntitiesDeferred()
          @decald = true
          ig.game.shake 0, 4
          @stomp.volume = 0.75
          @stomp.play()

      if @punching
        @spawnImpacts()
      else if @held > 0 and @held <= HELD_DURATION
        @pos.y -= 5


      @parent arguments...
