ig.module(
  'game.entities.mcds'
).requires(
  'game.entities.gibs'
  'impact.entity'
).defines ->
  ROW_COUNT = 3
  EPSILON = 1
  SCORE = 300

  window.EntityMcds = window.EntityHouse.extend
    size:
      x: 17
      y: 24
