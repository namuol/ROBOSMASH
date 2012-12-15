ig.module(
  'game.entities.paddle-player'
).requires(
  'game.entities.paddle',
  'game.entities.puck'
).defines ->
  window.EntityPaddlePlayer = EntityPaddle.extend
    animSheet: new ig.AnimationSheet 'media/paddle-b.png', 8, 32
    update: ->
      if ig.input.state @upstate
        @ay = -1
      else if ig.input.state @downstate
        @ay = 1
      else
        @ay = 0

      @parent()
