Parser = cc.Class.extend
  ctor: ->
    @bms =
      player     : null
      genre      : null
      title      : null
      artist     : null
      bpm        : null
      playLevel  : null
      rank       : null
      total      : null
      sategFile  : null
      keyNum     : null
      difficulty : null
      wav        : {}
      bmp        : {}
      data       : []
      totalNote  : 0
      # OPTIMIZE:
      bgms       : []
      animations : []
      bpms       : []
      lastTime   : {}

    @wavMessages = []


  parse : (bms_text) ->
    _ = require 'lodash'

    for row in bms_text.split '\n'
      _parse.call @, row

    _modifyAfterParse.call @
    # OPTIMIZE:bpm,bmp,wavは小節に依存しないよう配列に詰めなおす
    @bms.bpms[0] =
      timing : 0
      val : @bms.bpm
    _serialize @bms.bpms, "bpm", @bms.data
    _serialize @bms.animations, "bmp", @bms.data
    _serialize @bms.bgms, "wav", @bms.data

    @bms.totalNote = _calcTotalNote.call @

    # OPTIMIZE :
    @bms.lastTime.bgm = if @bms.bgms.length is 0 then 0 else _.max(@bms.bgms, 'timing').timing
    @bms.lastTime.note = _.max(_.map(_.last(@bms.data).note.key, (key) =>
      if key.timing.length isnt 0
        _.max(key.timing)
      else 0
    ))

    console.log "@bms.lastTime.bgm = #{@bms.lastTime.bgm}"
    console.log "@bms.lastTime.note = #{@bms.lastTime.note}"
    @bms

  _parse = (row)->
    if row.substring(0, 1) isnt '#'
      return

    wav = /^#WAV(\w{2}) +(.*)/.exec(row)
    if wav?
      _parseWAV.call @, wav
      return

    bmp = /^#BMP(\w{2}) +(.*)/.exec(row)
    if bmp?
      _parseBMP.call @, bmp
      return

    channelMsg = /^#([0-9]{3})([0-9]{2}):([\w\.]+)/.exec(row)
    if channelMsg?
      _parseChannelMsg.call @, channelMsg
      return

    property = /^#(\w+) +(.+)/.exec(row)
    if property?
      _parseProperty.call @, property
      return

  _parseWAV = (wav) ->
    index = parseInt(wav[1], 36)
    @bms.wav[index] = wav[2]

  _parseBMP = (bmp) ->
    index = parseInt(bmp[1], 36)
    @bms.bmp[index] = bmp[2]

  _parseProperty = (property)->
    @bms[property[1].toLowerCase()] = property[2]

  _createBar = ->
    {
      timing: 0.0
      wav :
        message: []
        timing: []
        id : []
      bmp :
        message: []
        timing : []
        id : []
      bpm :
        message: []
        timing : []
        val : []
      meter: 1.0
      note :
        key : ({ message: [], timing : [], id : [] } for _ in [0..8])
     }

  _parseChannelMsg = (msg)->
    measureNum = parseInt(msg[1])
    ch = parseInt(msg[2])
    data = msg[3]

    unless @bms.data[measureNum]?
      @bms.data[measureNum] = _createBar()

    switch ch
      when 1 # WAV
        _storeWAV.call @, data, @bms.data[measureNum].wav, measureNum
      when 2 # Meter
        meter = parseFloat(data)
        if meter > 0
          @bms.data[measureNum].meter = meter
      when 3 # BPM
        _storeBPM.call @, data, @bms.data[measureNum].bpm, measureNum
      when 4 # BMP
        _storeData.call @, data, @bms.data[measureNum].bmp, measureNum
      when 11, 12, 13, 14, 15
        _storeData.call @, data, @bms.data[measureNum].note.key[ch - 11], measureNum
      when 16, 17
        _storeData.call @, data, @bms.data[measureNum].note.key[ch - 9], measureNum
      when 18, 19
        _storeData.call @, data, @bms.data[measureNum].note.key[ch - 13], measureNum
      else

  _storeWAV = (msg, array, measureNum) ->
    if not @wavMessages[measureNum]?
      @wavMessages[measureNum] = []

    @wavMessages[measureNum].push (parseInt(msg[i..i+1],36) for i in [0..msg.length-1] by 2)

  _storeData = (msg, array, measureNum)->
    data = (parseInt(msg[i..i+1],36) for i in [0..msg.length-1] by 2)
    array.message = _merge(array.message, data)

  _storeBPM = (msg, bpm, measureNum) ->
    bpm.message = (parseInt(msg[i..i+1],16) for i in [0..msg.length-1] by 2)

  _lcm = (a,b) ->
    gcm = (x,y) ->
      if y==0 then x else gcm(y, x % y)
    return a / gcm(a,b) * b

  # ex. expand([1,2,3],6) == [1,0,2,0,3,0]
  _expand = (array, length) ->
    if array.length == 0
      return (0 for _ in [0..length-1])
    interval = length / array.length
    return ((if i % interval == 0 then array[i / interval] else 0) \
      for i in [0..length-1])

  # ex. merge([1,2,3], [0,4,0]) == [1,4,3]
  _merge = (ary1, ary2) ->
    if ary1.length == 0
      return ary2
    lcm = _lcm(ary1.length, ary2.length)
    ret = _expand(ary1, lcm)
    for value, i in _expand(ary2, lcm)
      continue if value == 0
      ret[i] = value
    return ret

  # 全体をパースした後でtiming等を修正
  _modifyAfterParse = () ->
    bpm = @bms.bpm
    time = 0
    for bar, i in @bms.data
      if not bar?
        @bms.data[i] = _createBar()
        @bms.data[i].timing = time
        time += (240000 / bpm)
        continue

      bar.timing = time
      if bar.bpm.message.length == 0
        bar.bpm.message = [0]

      _noteTiming(time, bar, bpm)
      _bmpTiming(time, bar, bpm)
      _wavTiming(time, bar, bpm, @wavMessages[i])

      l = bar.bpm.message.length
      for val, _ in bar.bpm.message
        if val != 0
          bar.bpm.val.push(val)
          bar.bpm.timing.push(time)
          bpm = val
        time += (240000 / bpm) * (1 / l) * bar.meter

  _calcTiming = (time, objects, bpmobj, bpm, meter) ->
    bl = bpmobj.message.length
    ol = objects.message.length
    lcm = _lcm(bl, ol)
    bpms = _expand(bpmobj.message, lcm)
    objs = _expand(objects.message, lcm)
    t = 0
    b = bpm
    objects.timing = []
    objects.id = []
    for val, i in bpms
      if objs[i] != 0
        objects.timing.push(time + t)
        objects.id.push(objs[i])
      if val != 0 # change bpm
        b = val
      t += (240000 / b) * (1 / lcm) * meter

  _noteTiming = (time, bar, bpm) ->
    l = bar.bpm.message.length
    for n in bar.note.key when n.message.length != 0
      _calcTiming(time, n, bar.bpm, bpm, bar.meter)

  _bmpTiming = (time, bar, bpm) ->
    _calcTiming(time, bar.bmp, bar.bpm, bpm, bar.meter)

  _wavTiming = (time, bar, bpm, wavss) ->
    if not wavss?
      cc.log('wavss is null')
      return
    l = bar.bpm.message.length
    result = []
    for ws in wavss
      wl = ws.length
      lcm = _lcm(l, wl)
      bpms = _expand(bar.bpm.message, lcm)
      wavs = _expand(ws, lcm)
      t = 0
      b = bpm
      for val, i in bpms
        if wavs[i] != 0
          result.push { timing: time + t, id: wavs[i]}
        if val != 0 # change bpm
          b = val
        t += (240000 / b) * (1 / lcm) * bar.meter

    for w in result.sort( (a,b) -> a['timing'] - b['timing'])
      bar.wav.timing.push w.timing
      bar.wav.id.push w.id

  # OPTIMIZE: bpm,bmp,wavは小節に依存しないよう配列に詰めなおす
  _serialize = (arr, name, bms_data) ->
    for v, i in bms_data
      for t, j in v[name].timing when t?
        if v[name].val?
          arr.push
            timing : t
            val : v[name].val[j]
        else if v[name].id?
          arr.push
            timing : t
            id : v[name].id[j]

  _calcTotalNote = () ->
    @bms.data.reduce ( (t, d) -> t +
      d.note.key.reduce ((nt, k) -> nt + k.id.length), 0), 0

module.exports = Parser
