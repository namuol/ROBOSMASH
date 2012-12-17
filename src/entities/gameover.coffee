ig.module(
  'game.entities.gameover'
).requires(
  'impact.entity'
).defines ->
  SPD = 25

  window.EntityGameover = ig.Entity.extend
    gravityFactor: 0
    zIndex: 28
    hurry: new ig.Sound 'media/sounds/hurry.*'
    gravityFactor: 0
    init: ->
      @parent arguments...

      ig.game.spawnEntity 'EntityUi_button', ig.system.width/2-33, 120,
        static: true
        text: 'more ... MORE!'
        onclick: ->
          ig.game.init()
    update: ->
      @parent arguments...
      if --@ttl < 0
        @kill()

    draw: ->
      ctx = ig.system.context
      fs = ctx.fillStyle
      ctx.fillStyle = 'rgba(0,0,0,0.4)'
      ctx.fillRect 0,0, ctx.canvas.width, ctx.canvas.height
      ctx.fillStyle = fs

      ig.game.font.draw 'GAME OVER.', ig.system.width/2,95, ig.Font.ALIGN.CENTER
      ig.game.font.draw @reason, ig.system.width/2, 104, ig.Font.ALIGN.CENTER
