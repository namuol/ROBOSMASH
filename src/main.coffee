ig.module(
  'game.main'
).requires(
  'impact.game'
  'impact.font'
  'game.levels.main'
  'game.levels.streets0'
  'game.entities.crosshair'
  'game.entities.fist'
  'game.entities.head'
  'game.entities.person'
  'game.entities.vehicle'
  'game.entities.bus'
  'game.entities.firetruck'
).defines ->
  MyGame = ig.Game.extend
    font: new ig.Font('media/04b03.font.png')
    gfx: new ig.Font('media/gfx.png')
    clearColor: '#d6eca3'

    pasteLevel: (lvl, y) ->
      # Delete first half of rows:
      i=0
      while i < 15
        @backgroundMaps[0].data.shift()
        ++i

      # Push new level rows:
      tiles = lvl.layer[0].data
      # TODO: Handle entities
      # entities = lvl.entities
     
      y = 0
      while y < 15
        @backgroundMaps[0].data.push tiles[y]
        ++y

    init: ->
      @loadLevel LevelMain
      @pasteLevel LevelStreets0, 0

      # Initialize your game here; bind keys etc.
      ig.input.bind ig.KEY.Z, 'punchL'
      ig.input.bind ig.KEY.C, 'punchR'

      ig.input.bind ig.KEY.MOUSE1, 'graspL'
      ig.input.bind ig.KEY.MOUSE2, 'graspR'

      ig.input.initMouse()
      ch = @spawnEntity 'EntityCrosshair', 0,0, {}
      @head = @spawnEntity 'EntityHead', 150/2 - 32,0, {}
      f1 = @spawnEntity 'EntityFist', -5,40,
        head: @head
        punch: ['graspL', 'punchL']
        crosshair: ch
      f2 = @spawnEntity 'EntityFist', 50,40,
        head: @head
        punch: ['graspR', 'punchR']
        crosshair: ch
      f1.other = f2
      f2.other = f1
      @head.feet = []
      @head.feet[0] = f1
      @head.feet[1] = f2
    time: Date.now()
    screen:
      x:0
      y:0

    shakex: 10
    shakey: 10

    shake: (x,y) ->
      @shakex += x
      @shakey += y

    update: ->
      # Update all entities and backgroundMaps

      @time = Date.now()

      #@screen.x += (@head.plant.x - ig.system.width/2 + 32 - @screen.x) * 0.05
      @screen.y += (@head.plant.y - @screen.y) * 0.05

      if Math.floor(Math.random() * 100) < 3
        @spawnEntity 'EntityPerson', Math.random()*150, @screen.y + Math.random()*200, {}
        @sortEntitiesDeferred()

      if Math.floor(Math.random() * 100) < 1
        @spawnEntity 'EntityVehicle', -17, @screen.y + Math.random()*200, {}
        @sortEntitiesDeferred()

      if Math.floor(Math.random() * 100) < 0.33
        @spawnEntity 'EntityBus', -17, @screen.y + Math.random()*200, {}
        @sortEntitiesDeferred()

      if Math.floor(Math.random() * 100) < 0.15
        @spawnEntity 'EntityFiretruck', -17, @screen.y + Math.random()*200, {}
        @sortEntitiesDeferred()
      
      @shx = -1 + 2*Math.random() * @shakex
      @shy = -1 + 2*Math.random() * @shakey

      #@screen.x += @shx
      @screen.y += @shy

      if @screen.y > 320
        @screen.y -= 320
        for e in @entities
          if e.posy
            e.posy -= 320
          e.pos.y -= 320

        @pasteLevel LevelStreets0

      @shakex *= 0.9
      @shakey *= 0.9

      @parent()

    draw: ->
      # Draw all entities and backgroundMaps
      @parent()

      #@screen.x -= @shx
      @screen.y -= @shy
 
  ig.System.drawMode = ig.System.DRAW.AUTHENTIC
  ig.main '#canvas', MyGame, 60, 150, 200, 3
