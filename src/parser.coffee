#_ = require 'lodash'

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
      exbpm      : {}
      stop       : {}
      totalNote  : 0
      # OPTIMIZE:
      bgms       : []
      animations : []
      bpms       : []
      stopTiming : []
      endTime    : 0

    @wavMessages = []


  parse : (bms_text) ->
    @_parse row for row in bms_text.split '\n'
    @_modifyAfterParse()
    # OPTIMIZE:bpm,bmp,wavは小節に依存しないよう配列に詰めなおす
    @bms.bpms[0] =
      timing : 0
      val : @bms.bpm
    @_serialize @bms.bpms, "bpm", @bms.data
    @_serialize @bms.animations, "bmp", @bms.data
    @_serialize @bms.bgms, "wav", @bms.data
    @_serialize @bms.stopTiming, "stop", @bms.data

    console.log "stopTiming"
    console.dir @bms.stopTiming

    @bms.totalNote = @_calcTotalNote()
    @bms

  _parse : (row) ->
    return if row.substring(0, 1) isnt '#'

    wav = /^#WAV(\w{2}) +(.*)/.exec(row)
    if wav?
      @_parseWAV wav
      return

    bmp = /^#BMP(\w{2}) +(.*)/.exec(row)
    if bmp?
      @_parseBMP bmp
      return

    stop = /^#STOP(\w{2}) +(.*)/.exec(row)
    if stop?
      @_parseSTOP stop
      return

    exbpm = /^#BPM(\w{2}) +(.*)/.exec(row)
    if exbpm?
      @_parseBPM exbpm
      return

    channelMsg = /^#([0-9]{3})([0-9]{2}):([\w\.]+)/.exec(row)
    if channelMsg?
      @_parseChannelMsg channelMsg
      return

    property = /^#(\w+) +(.+)/.exec(row)
    if property?
      @_parseProperty property
      return

  _parseWAV : (wav) ->
    index = parseInt wav[1], 36
    @bms.wav[index] = wav[2]

  _parseBMP : (bmp) ->
    index = parseInt bmp[1], 36
    @bms.bmp[index] = bmp[2]

  _parseSTOP : (stop) ->
    index = parseInt stop[1], 36
    @bms.stop[index] = stop[2]

  _parseBPM : (exbpm) ->
    index = parseInt exbpm[1], 36
    @bms.exbpm[index] = exbpm[2]

  _parseProperty : (property) ->
    @bms[property[1].toLowerCase()] = property[2]

  _createBar : ->
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
      stop :
        message: []
        timing : []
        id : []
      meter: 1.0
      note :
        key : ({ message: [], timing : [], id : [] } for i in [0..8])

  _parseChannelMsg : (msg) ->
    measureNum = parseInt msg[1]
    ch = parseInt msg[2]
    data = msg[3]

    unless @bms.data[measureNum]?
      @bms.data[measureNum] = @_createBar()

    switch ch
      when 1 # WAV
        @_storeWAV data, @bms.data[measureNum].wav, measureNum
      when 2 # Meter
        meter = parseFloat(data)
        if meter > 0
          @bms.data[measureNum].meter = meter
      when 3 # BPM
        @_storeBPM data, @bms.data[measureNum].bpm
      when 4 # BMP
        @_storeData data, @bms.data[measureNum].bmp
      when 8 # EXBPM
        @_storeEXBPM data, @bms.data[measureNum].bpm
      when 9 # STOP
        @_storeSTOP data, @bms.data[measureNum].stop
      when 11, 12, 13, 14, 15
        @_storeData data, @bms.data[measureNum].note.key[ch - 11]
      when 16, 17
        @_storeData data, @bms.data[measureNum].note.key[ch - 9]
      when 18, 19
        @_storeData data, @bms.data[measureNum].note.key[ch - 13]
      else

  _storeWAV : (msg, array, measureNum) ->
    @wavMessages[measureNum] ?= []
    @wavMessages[measureNum].push (parseInt(msg[i..i+1],36) for i in [0..msg.length-1] by 2)

  _storeData : (msg, array) ->
    data = (parseInt(msg[i..i+1],36) for i in [0..msg.length-1] by 2)
    array.message = _merge(array.message, data)

  _storeSTOP : (msg, array) ->
    data = (parseInt(msg[i..i+1],16) for i in [0..msg.length-1] by 2)
    array.message = _merge(array.message, data)

  _storeBPM : (msg, bpm) ->
    bpm.message = (parseInt(msg[i..i+1],16) for i in [0..msg.length-1] by 2)

  _storeEXBPM : (msg, bpm) ->
    bpm.message = for i in [0..msg.length-1] by 2
      if @bms.exbpm[parseInt(msg[i..i+1],16)]?
        parseFloat @bms.exbpm[parseInt(msg[i..i+1],16)]
      else 0
    console.log bpm.message


  _lcm = (a,b) ->
    gcm = (x,y) ->
      if y==0 then x else gcm(y, x % y)
    return a / gcm(a,b) * b

  # ex. expand([1,2,3],6) == [1,0,2,0,3,0]
  _expand = (array, length) ->
    return (0 for i in [0..length-1]) if array.length is 0
    interval = length / array.length
    return ((if i % interval == 0 then array[i / interval] else 0) \
      for i in [0..length-1])

  # ex. merge([1,2,3], [0,4,0]) == [1,4,3]
  _merge = (ary1, ary2) ->
    return ary2 if ary1.length is 0
    lcm = _lcm(ary1.length, ary2.length)
    ret = _expand(ary1, lcm)
    for value, i in _expand(ary2, lcm)
      continue if value == 0
      ret[i] = value
    return ret

  # 全体をパースした後でtiming等を修正
  _modifyAfterParse : () ->
    bpm = @bms.bpm
    time = 0
    for bar, i in @bms.data
      if not bar?
        @bms.data[i] = @_createBar()
        @bms.data[i].timing = time
        time += (240000 / bpm)
        continue

      bar.timing = time
      if bar.bpm.message.length == 0
        bar.bpm.message = [0]

      @_noteTiming time, bar, bpm
      @_bmpTiming time, bar, bpm
      @_stopTiming time, bar, bpm
      @_wavTiming time, bar, bpm, @wavMessages[i]

      l = bar.bpm.message.length
      for val, i in bar.bpm.message
        if val != 0
          bar.bpm.val.push(val)
          bar.bpm.timing.push(time)
          bpm = val
        time += (240000 / bpm) * (1 / l) * bar.meter

  _calcTiming : (time, objects, bpmobj, bpm, meter) ->
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
      if objs[i] isnt 0
        objects.timing.push(time + t)
        objects.id.push(objs[i])
        if @bms.endTime < time + t
          @bms.endTime = time + t

      b = val if val isnt 0 # change bpm
      t += (240000 / b) * (1 / lcm) * meter
    return

  _noteTiming : (time, bar, bpm) ->
    l = bar.bpm.message.length
    for n in bar.note.key when n.message.length isnt 0
      @_calcTiming(time, n, bar.bpm, bpm, bar.meter)
    return

  _bmpTiming : (time, bar, bpm) ->
    @_calcTiming time, bar.bmp, bar.bpm, bpm, bar.meter

  _stopTiming : (time, bar, bpm) ->
    @_calcTiming time, bar.stop, bar.bpm, bpm, bar.meter

  _wavTiming : (time, bar, bpm, wavss) ->
    return if not wavss?
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
        if wavs[i] isnt 0
          result.push { timing: time + t, id: wavs[i]}
          if @bms.endTime < time + t
            @bms.endTime = time + t
        if val isnt 0 # change bpm
          b = val
        t += (240000 / b) * (1 / lcm) * bar.meter

    for w in result.sort( (a,b) -> a['timing'] - b['timing'])
      bar.wav.timing.push w.timing
      bar.wav.id.push w.id

  # OPTIMIZE: bpm,bmp,wavは小節に依存しないよう配列に詰めなおす
  _serialize : (arr, name, bms_data) ->
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

  _calcTotalNote : ->
    @bms.data.reduce ( (t, d) -> t +
      d.note.key.reduce ((nt, k) -> nt + k.id.length), 0), 0

module.exports = Parser
