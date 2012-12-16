ig.module(
  'game.main'
).requires(
  'impact.game'
  'impact.font'
  'game.levels.main'
  'game.levels.streets0'
  'game.levels.streets1'
  'game.levels.streets2'
  'game.entities.crosshair'
  'game.entities.fist'
  'game.entities.head'
  'game.entities.person'
  'game.entities.vehicle'
  'game.entities.bus'
  'game.entities.firetruck'
  'game.entities.uibar'
).defines ->
  ig.Sound.use = [
    ig.Sound.FORMAT.OGG
    ig.Sound.FORMAT.MP3
    ig.Sound.FORMAT.M4A
  ]

  ig.Sound.channels = 2
  LEVEL_TYPE_CHANGES = [
    'rural'
    'suburban'
    'commercial'
    'urban'
  ]

  LEVEL_PROGRESS = [
      type:'suburban'
      time: 30
      dist: 3000
    ,
      type:'suburban'
      time: 30
      dist: 5000
    ,
  ]

  LEVEL_SEGMENTS =
    suburban: [
      LevelStreets0
      LevelStreets1
      LevelStreets2
    ]

  window.choose = (arr) ->
    arr[Math.floor(Math.random() * arr.length)]
  
  MAX_LIVES = 5
  START_LIVES = 3
  NEW_LIFE_COUNT = 75

  MyGame = ig.Game.extend
    # Sounds
    zapped: new ig.Sound 'media/sounds/zapped.*'
    lift: new ig.Sound 'media/sounds/lift.*'
    lifeup: new ig.Sound 'media/sounds/lifeup.*'
    stomp: new ig.Sound 'media/sounds/stomp.*'
    splode0: new ig.Sound 'media/sounds/splode0.*'
    splode1: new ig.Sound 'media/sounds/splode1.*'
    splode2: new ig.Sound 'media/sounds/splode2.*'
    splode3: new ig.Sound 'media/sounds/splode3.*'
    ui: new ig.AnimationSheet 'media/gfx.png', 32,32
    gravity: 900
    score: 0
    new_life_counter: 0
    lives: START_LIVES
    timeLeft: 0
    distLeft: 0
    font: new ig.Font('media/04b03.font.png')
    gfx: new ig.Font('media/gfx.png')
    clearColor: '#d6eca3'
    progress: 0
    gameOver: (reason) ->
      if confirm 'Game Over: ' + reason + '\nYour score was '+@score+'\nTry Again?'
        @init()

    scored: (score) ->
      if ++@new_life_counter >= NEW_LIFE_COUNT
        @lives = Math.min MAX_LIVES, @lives + 1
        @new_life_counter = 0
        @lifeup.volume = 0.75
        @lifeup.play()
      @score += score

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
      @lives = START_LIVES
      @score = 0

      @progress = 0
      @timeLeft = LEVEL_PROGRESS[@progress].time
      @distLeft = LEVEL_PROGRESS[@progress].dist

      @loadLevel LevelMain
      i=0
      for row in @backgroundMaps[1].data
        j=0
        for tile in row
          @backgroundMaps[1].data[i][j] = 0
        ++i


      # Initialize your game here; bind keys etc.
      ig.input.bind ig.KEY.Z, 'punchL'
      ig.input.bind ig.KEY.C, 'punchR'

      ig.input.bind ig.KEY.MOUSE1, 'graspL'
      ig.input.bind ig.KEY.MOUSE2, 'graspR'

      ig.input.initMouse()
      @timeMeter = new EntityUibar 2, ig.system.height-5,
        size:
          x:146
          y:3
        val:100
        max:100
        colors: [
            color:'#4ae54a'
            percent:0.5
          ,
            color:'#e5d14a'
            percent:0.33
          ,
            color:'#e71717'
            percent:0.15
        ]

      @distMeter = new EntityUibar 2, ig.system.height-159,
        size:
          x:3
          y:150
        vertical: true
        val:100
        max:100
        colors: [
            color:'white'
            percent:1
        ]

      @head = @spawnEntity 'EntityHead', 150/2 - 32,0, {}
      ch1 = @spawnEntity 'EntityCrosshair', 0,0,
        ox: -10
        oy: 0
      ch2 = @spawnEntity 'EntityCrosshair', 0,0,
        ox: 10
        oy: 0
      @f1 = @spawnEntity 'EntityFist', 5,40,
        head: @head
        punch: ['graspL', 'punchL']
        crosshair: ch1
      @f2 = @spawnEntity 'EntityFist', 42,40,
        head: @head
        punch: ['graspR', 'punchR']
        crosshair: ch2
      @f1.other = @f2
      @f2.other = @f1
      @head.feet = []
      @head.feet[0] = @f1
      @head.feet[1] = @f2
    time: Date.now()
    tock: 0
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
      ++@tock
      if @tock % 30 == 0
        console.log @entities.length
        #console.log @getEntitiesByType('EntityVehicle').length
      prev = @time
      if !prev
        prev = Date.now()
      @time = Date.now()
      
      @timeLeft -= (@time - prev)/1000

      #@screen.x += (@head.plant.x - ig.system.width/2 + 32 - @screen.x) * 0.05
      dy = (@head.pos.y - @screen.y) * 0.15
      
      if dy > 0
        @score += dy
        @screen.y += dy

        @distLeft -= dy
        if @distLeft <= 0
          @progress = Math.min LEVEL_PROGRESS.length-1, @progress + 1
          @timeLeft = LEVEL_PROGRESS[@progress].time
          @distLeft = LEVEL_PROGRESS[@progress].dist

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
          if typeof e.bottom == 'number'
            e.bottom -= 240
          e.pos.y -= 240

        @pasteLevel choose LEVEL_SEGMENTS[LEVEL_PROGRESS[@progress].type]

      @shakex *= 0.9
      @shakey *= 0.9

      @parent()

      if @timeLeft < 0
        @gameOver 'you didn\'t reach the checkpoint in time.'

    draw: ->
      # Draw all entities and backgroundMaps
      @parent()

      @screen.x -= @shx
      @screen.y -= @shy
      @timeMeter.max = LEVEL_PROGRESS[@progress].time
      @timeMeter.val = @timeLeft
      @timeMeter.draw()

      @distMeter.max = LEVEL_PROGRESS[@progress].dist
      @distMeter.val = @distMeter.max - @distLeft
      @distMeter.draw()

      oy = 8
      if @lives < MAX_LIVES
        @font.draw "next life: #{NEW_LIFE_COUNT - @new_life_counter}", ig.system.width-1, ig.system.height-32 - oy, ig.Font.ALIGN.RIGHT
      else
        @font.draw "MAX LIVES", ig.system.width-1, ig.system.height-32 - oy, ig.Font.ALIGN.RIGHT
      @font.draw Math.round(@score), ig.system.width-1, ig.system.height-8 - oy, ig.Font.ALIGN.RIGHT
      
      i=0
      while i < @lives
        @ui.image.drawTile ig.system.width - 12*i - 16, ig.system.height - 24 - oy, 8, 16
        ++i


 
  ig.System.drawMode = ig.System.DRAW.AUTHENTIC
  ig.main '#canvas', MyGame, 60, 150, 200, 3
