ig.module(
  'game.entities.vehicle'
).requires(
  'impact.entity'
).defines ->
  ROW_COUNT = 4
  EPSILON = 1
  MIN_SPD = 50
  SPD = 60

  window.EntityVehicle = ig.Entity.extend
    size:
      x: 16
      y: 16
    type: ig.Entity.TYPE.B
    mass: 200
    checkAgainst: ig.Entity.TYPE.A
    animSheet: new ig.AnimationSheet 'media/vehicles.png', 16,16
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

      if @pos.x > 150 or @pos.x < -16
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
