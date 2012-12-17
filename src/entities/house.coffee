ig.module(
  'game.entities.house'
).requires(
  'game.entities.gibs'
  'impact.entity'
).defines ->
  ROW_COUNT = 3
  EPSILON = 1
  SCORE = 300

  window.EntityHouse = ig.Entity.extend
    gravityFactor: 0
    size:
      x: 17
      y: 24
    type: ig.Entity.TYPE.B
    mass: 200
    checkAgainst: ig.Entity.TYPE.A
    animSheet: new ig.AnimationSheet 'media/houses.png', 17,24
    splode0: new ig.Sound 'media/sounds/splode0.*'
    splode1: new ig.Sound 'media/sounds/splode1.*'
    splode2: new ig.Sound 'media/sounds/splode2.*'
    splode3: new ig.Sound 'media/sounds/splode3.*'
    score: SCORE
    house:true
    init: (x,y, settings) ->
      @parent x,y, settings

      @addAnim 'idle', 5, [0], true
      @addAnim 'busted', 5, [1], true

      @num = Math.floor(Math.random() * ROW_COUNT)

      if @num
        for own k,anim of @anims
          i=0
          while i < anim.sequence.length
            anim.sequence[i] += @num * 2
            ++i

      if Math.random() < 0.2
        @hidden = true
      else
        @hidden = false
    draw: ->
      return if @hidden
      @parent arguments ...

    update: ->
      @parent arguments...

      if (@pos.y + @size.y) < ig.game.screen.y
        @kill()

    check: (other) ->
      return if @hidden
      return if other.head

      if @currentAnim == @anims.busted
        return

      snd = choose [
        @splode0
        @splode1
        @splode2
        @splode3
      ]
      snd.volume = 0.6
      snd.play()
      i = 0

      ig.game.spawnEntity 'EntityGibs', @pos.x, @pos.y,
        ox: 10
        oy: 10
        vx: 200
        vy: 300
        ttl: 50
        count: Math.floor(5 + Math.random()*5)
        anim: @currentAnim
      ig.game.spawnEntity 'EntityPeoplespawner', @pos.x, @pos.y,
        size:
          x:@size.x
          y:@size.y

      @currentAnim = @anims.busted
      ig.game.scored @score

      ig.game.sortEntitiesDeferred()
