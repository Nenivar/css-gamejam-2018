pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function new_entityfood(food, x, y)
  local ent = {}
  ent.food = food
  ent.x = x
  ent.y = y
  return ent
end
		  
onion = { snd = 10, chop = { 1, 0, 1, 0, 1, 0, 1, 0}, texture = 20 } 
carrot = { snd = 11, chop = { 1, 1, 1, 0, 1, 0, 1, 0}, texture = 18 }
pepper = { snd = 12, chop = { 1, 0, 1, 0, 1, 1, 0, 1}, texture = 16 }

level = {
  [1] = onion,
  [2] = carrot,
  [3] = onion,
  [5] = carrot,
  [6] = pepper,
  [7] = carrot,
  [8] = carrot,
  [9] = pepper,
  [10] = pepper,
  [12] = onion,
  [13] = carrot,
  [15] = carrot,
  [17] = pepper
}

next_food = {}

bpm = 60
crochet = 60 / bpm
note_crochet = crochet / 8
start_time = 0
cur_time = 0
cur_beat = 0
cur_note = 0
playing = false
score = 0
pressed = true

function _init()
  for i = 1, 3 do
    local f = (i - 1) + cur_beat
    local x = (64 - 8) + ((i - 1) * 24)
    if level[f] then
      next_food[i] = new_entityfood(level[f], x, 68)
    else
      next_food[i] = new_entityfood({ texture = 22 }, x, 68)
    end    
  end
  start_time = time()
  music(0)
end

function _update()
  cur_time = time() - start_time
  local prev_note = cur_note
  cur_beat = flr(cur_time / crochet)
  cur_note = (flr(cur_time / note_crochet) % 8) + 1
  if prev_note != cur_note then
    pressed = false
  end
  local nearest_note = flr((cur_time / note_crochet) + 0.5)
  -- if nothing is playing, or the new beat has started
  if not playing or (prev_note == 8 and cur_note == 1) then
    if level[cur_beat] != nil then
      sfx(level[cur_beat].snd, 2, 0, 8)
      playing = true
    end
  end

  local delta = abs((cur_time / note_crochet) - nearest_note)
  if btn(0) then
    if not pressed and delta < 0.3 and level[cur_beat] and level[cur_beat].chop[cur_note] == 1 then
      score += 10
      pressed = true
    end
  end

  if prev_note == 8 and cur_note == 1 then
    next_food[1] = next_food[2]
    next_food[1].x = 56
    next_food[2] = next_food[3]
    next_food[2].x = 80
    local f = cur_beat + 2
    if level[f] then
      next_food[3] = new_entityfood(level[f], 104, 68)
    else
      next_food[3] = new_entityfood({ texture = 22 }, 104, 68)
    end    
  end
end

t_x = 63
t_y = 2
t_w = 64
t_h = 20
b_sep = (t_w * 1.5) / 16

function drawrootline() 
  local next_b = ceil(cur_time / crochet)
  local delta = abs((cur_time / crochet) - next_b)
  if delta < 0.1 then
    rectfill(t_x - 1, t_y - 1, t_x + 1, t_y + t_h + 1, 8)
  else 
    line(t_x, t_y, t_x, t_y + t_h, 8)
  end
  
end

function drawnextfood() 
  for i = 1, 3 do
    if (next_food[i]) then
      spr(next_food[i].food.texture, next_food[i].x, next_food[i].y, 2, 2)
    end
  end
end

function _draw()
	cls()

  -- map
  map(0, 0, 0, 0, 16, 16)

  
  local end_time = cur_time + ((bpm / 60) * 2)
  local end_beat = flr(end_time / crochet)
  local beat_offset = ((cur_time / crochet) - cur_beat)
  print("score: " .. score .. "\nbeat: " .. cur_beat .. "\nnote: " .. cur_note, 0, 0, 7)
  
  clip(t_x, t_y, t_x + t_w, t_y + t_h)
  for b = cur_beat, end_beat do
    for n = 1, 8 do
      if b != cur_beat or n >= cur_note then
        local x = t_x - (beat_offset * 8 * b_sep) + (((n - 1) + ((b - cur_beat) * 8)) * b_sep)
        local y = t_y
        local h = t_h
        local c = 12
        if level[b] == nil or level[b].chop[n] == 0 then
          y = t_y + 4
          h = h - 8
          c = 5
        end
        line(x, y, x, y + h, c)
      end
    end
  end
  clip()
  drawrootline()
  drawnextfood()
  -- choppy gal
  if btn(0) then
    spr(130, 40, 60, 2.625, 4)
  else
    spr(128, 40, 60, 2, 4)
  end
  --line(t_x, t_y, t_x, t_y + t_h, 3)
end
__gfx__
00000000000000b0000022404444444444444444000000a099999999999999999999999900002000888888888888888888888888000000000000000000000000
000000000009903b00992f0044eeee4444bbbb44000004b399cccc9999eeee9999bbbb99002783b088cccc8888eeee8888bbbb88000000000000000000000000
0070070004f77f3009f7f7f044e44e4444b44b440000f94b99c9999999e9999999b999990e28873288c88c8888e88e8888b88b88000000000000000000000000
000770000f77779097f7777f44e44e4444b44b44000f940399c9999999e9999999b999998788887288c88c8888e88e8888b88b88000000000000000000000000
000770009777ff90f7777f7f44e44e4444b44b440049400099c9999999e9999999b999992888888088cccc8888eeee8888bbbb88000000000000000000000000
007007000f7f7f00977f7f7944e44e4444b44b440f94000099c9999999e9999999b999992828872088c8888888e8888888b88888000000000000000000000000
0000000004f7f400097f7f9044eeee4444bbbb440940000099cccc9999eeee9999bbbb990282e20088c8888888e8888888b88888000000000000000000000000
000000000049000000f9490044444444444444449400000099999999999999999999999900282000888888888888888888888888000000000000000000000000
000000000000000000000000000b000000000000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b000000000000000000a00300000000b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000ab0000000000000000003b300000000533500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002222b3222000000000000003b3bba000059f93f95000000077770000000000000000000000000000000000000000000000000000000000000000000000000
0022783338e22000000000000443b0300005a79afaff500000000070000000000000000000000000000000000000000000000000000000000000000000000000
002887ee87882000000000004f9430000009f9a79f9f900000000700000000000000000000000000000000000000000000000000000000000000000000000000
002882222888e0000000000459f4000000597979ff9f950000007000000000000000000000000000000000000000000000000000000000000000000000000000
00e888828888e0000000004f994000000059f979af9a950000077770007777000066666666666660000000000000000000000000000000000000000000000000
00e888888888200000000099940000000059f97fff9f950000000000000070006666666666666666000000000000000000000000000000000000000000000000
00e888888888e00000000f99400000000059af97fa9f950000000000000700000006666666666000000000000000000000000000000000000000000000000000
00288888888820000000494000000000000f9afaf9ff900000000000007777000000000000000000000000000000000000000000000000000000000000000000
000288828882000000049900000000000005ffa9afa9500000000777000000000000000000000000000000000000000000000000000000000000000000000000
0002888228820000004950000000000000005993fa95000000000070000000000000000000000000000000000000000000000000000000000000000000000000
000022202220000000940000000000000000003b3300000000000777000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b33b3333b33b3333b33b3333bb9999999999bb3b3bb3b3bb3bb3b3b000000000000000000000000000000000000000000000000000000000000000000000000
bb3b33b3be3b33b3bb3b33b3b99ffffffffff99b3b3bb3b33b3bb3b3000000000000000000000000000000000000000000000000000000000000000000000000
333333bbeae333bb333333bb9ff9999999999ff9d1dd1dd11dd1dd1d000000000000000000000000000000000000000000000000000000000000000000000000
3b3bb3333e3bb3333b3bb3339f9ffffffffff9f9d1dd1dd11dd1dd1d000000000000000000000000000000000000000000000000000000000000000000000000
3333b3bb3333b3bb333763bb5ffffffffffffff5d1dd1dd11dd1dd1d000000000000000000000000000000000000000000000000000000000000000000000000
33b333b333b33eb3335655b3555ffffffffff555555d15555551d555000000000000000000000000000000000000000000000000000000000000000000000000
3bb3b3333bb3eae33bb3b33354455555555555455d5335d55d5335d5000000000000000000000000000000000000000000000000000000000000000000000000
333b3b3b333b3e3b333b3b3b5444445454444445555b3555555b3555000000000000000000000000000000000000000000000000000000000000000000000000
3b33b3333b33b3333b33b33354454544545445450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb3b33b3bb3b33b3bb3b33b354454545445445450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333bb333333bb333333bb54544544444545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3bb3333b3bb3333b3bb33354544545444544450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333b3bb3333b3bb3333b3bb54544545444545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33b333b333b333b333b333b335444453544554530000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3bb3b3333bb4b3333bb3b3334434535b3453345b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333b3b3434d5454b433b3b3b53b53bb3b53bbb450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b33b33355d455443b33b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb3b33b445545455db3b33b300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333b544554d55433333bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3bb3d5545445445b3bb33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333b344554544454533b3bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33b333b554545545d4b333b300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3bb3b3344d45545454b3b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333b3b3b5544554d433b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b33b334446554434b33b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb3b33b3bb3456b3bb3b33b300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333bb333333bb333333bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3bb3333b3bb3333b3bb33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3333b3bb3333b3bb3333b3bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33b333b333b333b333b333b300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3bb3b3333bb3b3333bb3b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333b3b3b333b3b3b333b3b3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707700000000000770770000000000000000000000000000077070700000000000000000000000000002222222200000000000000000000000000000000000
07777222000000000777722200000000000000000000000000077077700000000000000000000000000022222222200000000000000000000000000000000000
20777200000000002077720000000000000000000000000000077077700000000000000000000000000222222222220000000000000000000000000000000000
22722220000000002272222000000000000000000000000000077777700000000000000000000000000222222222220000000000000000000000000000000000
22222212000000002222221200000000000000000000000000077777700000000000000000000000002222222222220000000000000000000000000000000000
00222222220022000022222222002200000000000000000000007777700000000000000000000000022222222222220000000000000000000000000000000000
00212222222211260021222222221120000000000000000000007777700000000000000000000000222222222222220000000000000000000000000000000000
00222222222212260022222222221220000000000000000000000777700000000000000000000002022222222222222000000000000000000000000000000000
002222d222222226002222d222222220000000000000000000000777700000000000000000000002022222222222222200000000000000000000000000000000
0022222ddd2222200022222ddd222220000000000000000000000777700000000000000000000000222222222222222020000000000000000000000000000000
0022222222dddd000022222222dddd00000000000000000000000777700000000000000000000000220222222222222020000000000000000000000000000000
00722222200054000072222220000000000000000000000000000777700000000000000000000000222222222222222020000000000000000000000000000000
00277722700024000027772270000000000000000000000000000777700000000000000000000000220222222022220200000000000000000000000000000000
00277722700222500027772270000000000000000000000000000777700000000000000000000000220022222222022000000000000000000000000000000000
00277722700220000027772270000000000000000000000000000777700000000000000000000000220022222222220000000000000000000000000000000000
00277722702220000027772270000050000000000000000000000707700000000000000000000000202002222222220000000000000000000000000000000000
00227777722200000022777772222444444440000000000000000707700000000000000000000000220202222222270000000000000000000000000000000000
002227777220000000222777722225200ddd60000000000000000707700000000000000000000000020222222222070000000000000000000000000000000000
00222275720000000022227570000000066660000000000000000707700000000000000000000000070222022200070000000000000000000000000000000000
00272227700000000027222770000000000000000000000000000707700000000000000000000000072222222207270200000000000000000000000000000000
00277527700000000027752770000000000000000000000000000707000000000000000000000000077222222227772020000000000000000000000000000000
00277575700000000027757570000000000000000000000000000007000000000000000000000000072720000007702222200000000000000000000000000000
00777777700000000077777770000000000000000000000000700007000000000000000000000020002200000007700222222000000000000000000000000000
00277777700000000027777770000000000000000000000000700007000000000000000000000020022200000007702222202200000000000000000000000000
00277777700000000027777770000000000000000000000000700777700000000000000000002200022700000007702222222220000000000000000000000000
00277777700000000027777770000000000000000000000000000000000000000000000000002220227777777777702222222222000000000000000000000000
00277777700000000027777770000000000000000000000000000000000000000000000000022222227777777772200022222202000000000000000000000000
00277777700000000027777770000000000000000000000000000000000000000000000000022022207707770727200000222222000000000000000000000000
00220022000000000022002200000000000000000000000000000000000000000000000000222222207777777722200000222222000000000000000000000000
00220022000000000022002200000000000000000000000000000000000000000000000002222222707777772227770002222222000000000000000000000000
00220022000000000022002200000000000000000000000000000000000000000000000022202200707777777777700020222222000000000000000000000000
00222022200000000022202220000000000000000000000000000000000000000000000022022000777070770707700202220222000000000000000000000000
00222022200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0f0f0f0f0f0f0f0f0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
616161616161616161626161616161610d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
616161617171717171407171716061610d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
617171714040404041404060616161610d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
715151404042404040404040717171710d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
516161624040404040404140404040400d0d0d0d0d0d0d0d0d0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
616161624040404040404040404040400d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
617171414040404040404040404041400d0d0d0d0d0d0d0d0d0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7140426140404043444545454545454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404053544040404040405100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4042404040404040404040404040416100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040514040416140404240404040516100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5151615151514040404040515160616100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6161626161616240414060616161616100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010f00000c0430000000000000000c0430000000000000000c0430000000000000000c043000000c0000c0000c0430000000000000000c0430000000000000000c0430000000000000000c043000000c0000c000
010f00000c6000000000000000000c6430000000000000000c6000000000000000000c6430000000000000000c6000000000000000000c6430000000000000000c6000000000000000000c643000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003b01500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001a5531a5001a5532d4001a5531b1001a5531b1001a1001b1001a1001b1001a5001a5001a5001a5001a500276001a5002d4002f4002f4002b4002d4002640026400264002940000000000000000000000
010f000027233272332723339700272333970027233397002d700397002d700397002d70039700397002d700397002d700397002d700397002d700397002d700397002d700397002d700397002d7000000000000
010f00001745315400174530c00017453174530c00017453000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 00014a44

