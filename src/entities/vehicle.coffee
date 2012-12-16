ig.module(
  'game.entities.vehicle'
).requires(
  'game.entities.gibs'
  'impact.entity'
).defines ->
  ROW_COUNT = 4
  EPSILON = 1
  MIN_SPD = 50
  SPD = 60

  window.EntityVehicle = ig.Entity.extend
    gravityFactor: 0
    size:
      x: 16
      y: 16
    type: ig.Entity.TYPE.B
    mass: 200
    checkAgainst: ig.Entity.TYPE.A
    animSheet: new ig.AnimationSheet 'media/vehicles.png', 16,13
    splode0: new ig.Sound 'media/sounds/splode0.*'
    splode1: new ig.Sound 'media/sounds/splode1.*'
    splode2: new ig.Sound 'media/sounds/splode2.*'
    splode3: new ig.Sound 'media/sounds/splode3.*'
    init: (x,y, settings) ->
      @parent x,y, settings

      @addAnim 'go', 0.05, [0,1]

      @num = Math.floor(Math.random() * ROW_COUNT)

      if @num
        for own k,anim of @anims
          i=0
          while i < anim.sequence.length
            anim.sequence[i] += @num * 2
            ++i
      @vel.y = 0
      @vel.x = MIN_SPD + (Math.random() * SPD)

      if Math.random() < 0.5
        @pos.x = 150
        @currentAnim.flip.x = true
        @vel.x *= -1

    update: ->
      @parent arguments...

      if @pos.x > ig.system.width or @pos.x < -@size.x
        @kill()

    check: (other) ->
      snd = choose [
        @splode0
        @splode1
        @splode2
        @splode3
      ]
      snd.volume = 0.6
      snd.play()
      @kill()
      i = 0

      ig.game.spawnEntity 'EntityGibs', @pos.x, @pos.y,
        ox: 10
        oy: 10
        vx: 200
        vy: 300
        ttl: 250
        count: Math.floor(5 + Math.random()*5)
        anim: @currentAnim

      ig.game.sortEntitiesDeferred()
