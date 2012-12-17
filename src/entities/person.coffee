ig.module(
  'game.entities.person'
).requires(
  'impact.entity'
).defines ->
  ROW_COUNT = 6
  EPSILON = 1

  window.EntityPerson = ig.Entity.extend
    gravityFactor: 0
    size:
      x: 7
      y: 8
    type: ig.Entity.TYPE.B
    checkAgainst: ig.Entity.TYPE.A
    animSheet: new ig.AnimationSheet 'media/ppl.png', 8,9
    person: true
    init: (x,y, settings) ->
      @parent x,y, settings
      @num = Math.floor(Math.random() * ROW_COUNT)
      @addAnim 'idle_down', 5, [0], true
      @addAnim 'idle_up', 5, [3], true
      @addAnim 'run_down', 0.15, [1,0,2,0]
      @addAnim 'run_up', 0.15, [4,3,5,3]

      if @num
        for own k,anim of @anims
          i=0
          while i < anim.sequence.length
            anim.sequence[i] += @num * 6
            ++i

      @vel.y = 10 + Math.random()*10
      @vel.x = -10 + Math.random()*20
    update: ->
      if (@vel.y > EPSILON)
        if @currentAnim != @anims.run_down
          @currentAnim = @anims.run_down
      else if (@vel.y < -EPSILON)
        if @currentAnim != @anims.run_up
          @currentAnim = @anims.run_up
      else
        if @currentAnim == @anims.run_down
          @currentAnim = @anims.idle_down
        else if @currentAnim == @anims.run_up
          @currentAnim = @anims.idle_up


      @parent arguments...

      if ((@pos.y + @size.y) < ig.game.screen.y) or (@pos.y > ig.game.screen.y + ig.system.height*1.25)
        @kill()

    check: (other) ->
      @kill()
