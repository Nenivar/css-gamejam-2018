pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function new_entityfood(food, x, y)
		local ent = {}
		ent.food = food
		ent.x = x
		ent.y = y
		ent.progress = 0
		ent.advance = function(this)
		  progress = (progress + 1) % 4
	 end
end
		  
onion = { snd = 10, chop = { 1, 0, 1, 0, 1, 0, 1, 0}, texture = 1 } 

level = {
		[2] = onion,
		[4] = onion,
		[8] = onion
}

bpm = 120
crochet = 60 / bpm
note_crochet = crochet / 4
start_time = 0
cur_beat = 0
cur_note = 0
playing = false

function _init()
	 start_time = time()
	 music(0)
end

x = 64  y = 64
function _update()
  cur = time() - start_time
  cur_beat = flr(cur / crochet)
  cur_note = flr(cur / note_crochet)
end

function _draw()
	 cls()
  print("beat: " .. cur_beat .. "\nnote: " .. cur_note, 0, 0)
end
__gfx__
00000000444444444444444444444444444444449999999999999999999999999999999988888888888888888888888888888888000000000000000000000000
000000004477774444cccc4444eeee4444bbbb449977779999cccc9999eeee9999bbbb998877778888cccc8888eeee8888bbbb88000000000000000000000000
007007004474474444c44c4444e44e4444b44b449979999999c9999999e9999999b999998878878888c88c8888e88e8888b88b88000000000000000000000000
000770004474474444c44c4444e44e4444b44b449979999999c9999999e9999999b999998878878888c88c8888e88e8888b88b88000000000000000000000000
000770004474474444c44c4444e44e4444b44b449979999999c9999999e9999999b999998877778888cccc8888eeee8888bbbb88000000000000000000000000
007007004474474444c44c4444e44e4444b44b449979999999c9999999e9999999b999998878888888c8888888e8888888b88888000000000000000000000000
000000004477774444cccc4444eeee4444bbbb449977779999cccc9999eeee9999bbbb998878888888c8888888e8888888b88888000000000000000000000000
00000000444444444444444444444444444444449999999999999999999999999999999988888888888888888888888888888888000000000000000000000000
__map__
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010f00000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c0430000000000000000c043000000000000000
010f00000c6000000000000000000c6430000000000000000c6000000000000000000c6430000000000000000c6000000000000000000c6430000000000000000c6000000000000000000c643000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001a5531a5001a5532d4001a5531b1001a5531b1001a1001b1001a1001b1001a5001a5001a5001a5001a500276001a5002d4002f4002f4002b4002d4002640026400264002940000000000000000000000
010f000027233272332723339700272333970027233397002d700397002d700397002d70039700397002d700397002d700397002d700397002d700397002d700397002d700397002d700397002d7000000000000
010f00001745315400174530c00017453174530c00017453000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 00014a44

