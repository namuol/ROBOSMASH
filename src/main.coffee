ig.module(
  'game.main'
).requires(
  'impact.game'
  'impact.font'
  'game.levels.main'
  'game.levels.streets0'
  'game.levels.streets1'
  'game.entities.crosshair'
  'game.entities.fist'
  'game.entities.head'
  'game.entities.person'
  'game.entities.vehicle'
  'game.entities.bus'
  'game.entities.firetruck'
).defines ->
  ig.Sound.use = [
    ig.Sound.FORMAT.OGG
    ig.Sound.FORMAT.MP3
    ig.Sound.FORMAT.M4A
  ]

  LEVEL_SEGMENTS =
    suburban: [
      LevelStreets0
      LevelStreets1
    ]

  window.choose = (arr) ->
    arr[Math.floor(Math.random() * arr.length)]

  MyGame = ig.Game.extend
    # Sounds
    zapped: new ig.Sound 'media/sounds/zapped.*'
    stomp: new ig.Sound 'media/sounds/stomp.*'
    splode0: new ig.Sound 'media/sounds/splode0.*'
    splode1: new ig.Sound 'media/sounds/splode1.*'
    splode2: new ig.Sound 'media/sounds/splode2.*'
    splode3: new ig.Sound 'media/sounds/splode3.*'

    currentLevelType: 'suburban'
    font: new ig.Font('media/04b03.font.png')
    gfx: new ig.Font('media/gfx.png')
    clearColor: '#d6eca3'

    pasteLevel: (lvl, y) ->
      # Delete first half of rows:
      i=0
      while i < 15
        @backgroundMaps[1].data.shift()
        ++i

      # Push new level rows:
      tiles = lvl.layer[0].data
      # TODO: Handle entities
      entities = lvl.entities
      for e in entities
        @spawnEntity e.type, e.x, e.y+240, e.settings
     
      y = 0
      while y < 15
        @backgroundMaps[1].data.push tiles[y]
        ++y

    init: ->
      @loadLevel LevelMain

      # Initialize your game here; bind keys etc.
      ig.input.bind ig.KEY.Z, 'punchL'
      ig.input.bind ig.KEY.C, 'punchR'

      ig.input.bind ig.KEY.MOUSE1, 'graspL'
      ig.input.bind ig.KEY.MOUSE2, 'graspR'

      ig.input.initMouse()
      ch = @spawnEntity 'EntityCrosshair', 0,0, {}
      @head = @spawnEntity 'EntityHead', 150/2 - 32,0, {}
      @f1 = @spawnEntity 'EntityFist', -5,40,
        head: @head
        punch: ['graspL', 'punchL']
        crosshair: ch
      @f2 = @spawnEntity 'EntityFist', 50,40,
        head: @head
        punch: ['graspR', 'punchR']
        crosshair: ch
      @f1.other = @f2
      @f2.other = @f1
      @head.feet = []
      @head.feet[0] = @f1
      @head.feet[1] = @f2
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
      @screen.y += (@head.pos.y - @screen.y) * 0.15

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
      
      @shx = 2*Math.random() * @shakex
      @shy = 2*Math.random() * @shakey

      @screen.x += @shx
      @screen.y += @shy

      if @screen.y > 240
        @screen.y -= 240
        @head.plant.y -= 240
        @f1.prevy -= 240
        @f1.stickY -= 240
        @f2.prevy -= 240
        @f2.stickY -= 240

        for e in @entities
          e.pos.y -= 240

        @pasteLevel choose LEVEL_SEGMENTS[@currentLevelType]


      @shakex *= 0.9
      @shakey *= 0.9

      @parent()

    draw: ->
      # Draw all entities and backgroundMaps
      @parent()

      @screen.x -= @shx
      @screen.y -= @shy
 
  ig.System.drawMode = ig.System.DRAW.AUTHENTIC
  ig.main '#canvas', MyGame, 60, 150, 200, 3
