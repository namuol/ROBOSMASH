ig.module(
  'game.entities.ui_button'
).requires(
  'impact.entity'
).defines ->
  window.EntityUi_button = ig.Entity.extend
    _wmDrawBox: true
    _wmScalable: true
    active: false
    hover: false
    disabled: false
    gravityFactor: 0
    mouseover: ->
    mouseout: ->
    pressed: ->
      @active = true
      if @onpress
        eval @onpress
    released: ->
      @active = false
      if @hover and @onclick
        if typeof @onclick is 'function'
          @onclick()
        else
          eval @onclick
    init: (x,y, settings) ->
      @settings = settings
      @tooltip = @settings.tooltip
      @onpress = @settings.onpress
      @text = @settings.text or ''
      @parent arguments...
    text: ''
    highlighted: false
    highlight_ticks: 0
    highlight: (duration=24) ->
      @highlight_ticks = duration
      @highlighted = true
    idle_col: '#7abcb5'
    hover_col: '#8cd2cb'
    active_col: '#7abcb5'
    disabled_col: '#7abcb5'
    highlighted_col: 'rgba(255,0,0,1)'
    zIndex: 900
    draw: ->
      if @active
        @pos.y += 1

      if @text.length > 0 and ig.game.font
        @size =
          x: ig.game.font.widthForString @text + 2
          y: ig.game.font.heightForString @text + 2

      ctx = ig.system.context
      p = (a) -> Math.round(a) *3#ig.system.getDrawPos
      if @static
        sx = sy = 0
      else
        sx = ig.game.screen.x
        sy = ig.game.screen.y

      if @currentAnim and @num
        @currentAnim.draw @pos.x-sx, @pos.y-sy
      else
        if @highlighted
          if @highlight_ticks % 20 < 10
            fillStyle = @highlighted_col
          else
            fillStyle = @idle_col
          if --@highlight_ticks <= 0
            @highlighted = false
        else if @disabled
          fillStyle = @disabled_col
        else if @active
          fillStyle = @active_col
        else if @hover
          fillStyle = @hover_col
        else
          fillStyle = @idle_col

        prevFillStyle = ctx.fillStyle
        ctx.fillStyle = fillStyle
        ctx.fillRect p(@pos.x-sx), p(@pos.y-sy), p(@size.x), p(@size.y)
        ctx.fillStyle = prevFillStyle

      if @text and ig.game.font
        ig.game.font.draw @text, @pos.x+3-sx, @pos.y+2-sy

      if @hover and @tooltip and ig.game.font
        ig.game.font.draw @tooltip, ig.input.mouse.x, ig.input.mouse.y - 8

      if @active
        @pos.y -= 1

    defer: (func, ticks=1) ->
      if not @to_defer?
        @to_defer = []
      @to_defer.push
        func:func
        ticks:ticks

    update: ->
      return if ig.game.transitioning

      if @to_defer?
        to_remove = []
        i=0
        for d in @to_defer
          if d.ticks <= 0
            d.func()
            to_remove.push i
          else
            --d.ticks
          ++i

        for idx in to_remove
          @to_defer.splice idx, 1

      if ig.game.disableButtons
        @parent arguments...

      x = @pos.x
      y = @pos.y
      if not @static
        mx = ig.input.mouse.x + ig.game.screen.x
        my = ig.input.mouse.y + ig.game.screen.y
      else
        mx = ig.input.mouse.x
        my = ig.input.mouse.y

      _hover_prev = @hover

      if mx > x and mx < x+@size.x and my > y and my < y+@size.y
        @hover = true
      else
        @hover = false
      
      if !@disabled
        if @hover and ig.input.pressed 'graspL'
          @pressed()

        if @hover and (not _hover_prev)
          @mouseover()
        else if (not @hover) and _hover_prev
          @mouseout()

        if @active and ig.input.released 'graspL'
          @released()

      @parent arguments...
