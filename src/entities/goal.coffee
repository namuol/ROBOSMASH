ig.module(
  'game.entities.goal'
).requires(
  'impact.entity'
).defines ->
  window.EntityGoal = ig.Entity.extend
    size:
      x: 16
      y: 16
    type: ig.Entity.TYPE.A
    score: 0
    checkAgainst: ig.Entity.TYPE.B
    _wmScalable: true
    _wmDrawBox: true
    _wmBoxColor: 'rgba(255,0,0,0.5)'
    check: (puck) ->
      player = ig.game.getEntityByName @player
      puck.reset(player.pos.x < 128)
