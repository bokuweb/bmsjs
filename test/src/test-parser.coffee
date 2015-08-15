ParserTest = cc.Class.extend

  start : ->
    expect = chai.expect
    Parser = require '../../src/parser'

    describe 'Parser class test', ->
      parser = null

      it 'parse WAV', ->
        text = """
          #WAV00 test1.ogg
          #WAV01 test2.ogg
          #WAV02 test3.ogg
          #WAV04 test4.ogg
        """
        parser = new Parser()
        result = parser.parse(text)
        expect(result.wav[0]).to.be.equal('test1.ogg')
        expect(result.wav[1]).to.be.equal('test2.ogg')
        expect(result.wav[2]).to.be.equal('test3.ogg')
        expect(result.wav[4]).to.be.equal('test4.ogg')

      it 'parse BMP', ->
        text = """
          #BMP00 test1.bmp
          #BMP01 test2.bmp
          #BMP02 test3.bmp
          #BMP04 test4.bmp
        """
        parser = new Parser()
        result = parser.parse(text)
        expect(result.bmp[0]).to.be.equal('test1.bmp')
        expect(result.bmp[1]).to.be.equal('test2.bmp')
        expect(result.bmp[2]).to.be.equal('test3.bmp')
        expect(result.bmp[4]).to.be.equal('test4.bmp')

      it 'parse property', ->
        text = """
          #PLAYER 1
          #GENRE hoge
          #BPM 55
        """
        parser = new Parser()
        result = parser.parse(text)
        expect(result.player).to.be.equal('1')
        expect(result.genre).to.be.equal('hoge')
        expect(result.bpm).to.be.equal('55')

      it 'parse channel message', ->
        text = """
          #00011:11111111
          #00011:0022332255224400
          #00011:0066
        """
        parser = new Parser()
        result = parser.parse(text)

        expect(result.data[0].note.key[0].id[0]).to.be.equal(parseInt('11', 36))
        expect(result.data[0].note.key[0].id[1]).to.be.equal(parseInt('22', 36))
        expect(result.data[0].note.key[0].id[2]).to.be.equal(parseInt('33', 36))
        expect(result.data[0].note.key[0].id[3]).to.be.equal(parseInt('22', 36))
        expect(result.data[0].note.key[0].id[4]).to.be.equal(parseInt('66', 36))
        expect(result.data[0].note.key[0].id[5]).to.be.equal(parseInt('22', 36))
        expect(result.data[0].note.key[0].id[6]).to.be.equal(parseInt('44', 36))

        expect(result.totalNote).to.be.equal(7)

      it 'parse WAV', ->
        text = """
          #PLAYER 1
          #GENRE hoge
          #BPM 60

          #00001:6F
          #00001:0007000700070007
          #00001:3B
        """
        parser = new Parser()
        result = parser.parse(text)

        #FIXME: 上２つは同時なので順序が入れ替わる可能性がある
        expect(result.data[0].wav.id[0]).to.be.equal(parseInt('6F', 36))
        expect(result.data[0].wav.id[1]).to.be.equal(parseInt('3B', 36))
        expect(result.data[0].wav.id[2]).to.be.equal(parseInt('07', 36))
        expect(result.data[0].wav.id[3]).to.be.equal(parseInt('07', 36))
        expect(result.data[0].wav.id[4]).to.be.equal(parseInt('07', 36))
        expect(result.data[0].wav.id[5]).to.be.equal(parseInt('07', 36))

      it 'parse BMP', ->
        text = """
          #00004:11111111
          #00004:0022332255224400
          #00004:0066
        """
        parser = new Parser()
        result = parser.parse(text)

        expect(result.data[0].bmp.id[0]).to.be.equal(parseInt('11', 36))
        expect(result.data[0].bmp.id[1]).to.be.equal(parseInt('22', 36))
        expect(result.data[0].bmp.id[2]).to.be.equal(parseInt('33', 36))
        expect(result.data[0].bmp.id[3]).to.be.equal(parseInt('22', 36))
        expect(result.data[0].bmp.id[4]).to.be.equal(parseInt('66', 36))
        expect(result.data[0].bmp.id[5]).to.be.equal(parseInt('22', 36))
        expect(result.data[0].bmp.id[6]).to.be.equal(parseInt('44', 36))

      it 'calc total note', ->
        text = """
          #PLAYER 1
          #GENRE hoge
          #BPM 60

          #00011:1111
          #00012:0022332255224400
          #00013:0066

          #00111:1212
          #00211:13
        """
        parser = new Parser()
        result = parser.parse(text)

        expect(result.totalNote).to.be.equal(12)


module.exports = ParserTest


