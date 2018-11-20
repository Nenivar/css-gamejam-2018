pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function new_entityfood(food, x, y)
  local ent = {}
  ent.food = food
  ent.x = x
  ent.y = y
  ent.progress = 0
  return ent
end
		  
onion = { snd = 10, chop = { 1, 0, 1, 0, 1, 0, 1, 0}, texture = 1 } 
carrot = { snd = 11, chop = { 1, 1, 1, 0, 1, 0, 1, 0}, texture = 5 }
pepper = { snd = 12, chop = { 1, 0, 1, 0, 1, 1, 0, 1}, texture = 9 }

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
      next_food[i] = new_entityfood(level[f], x, 56)
    else
      next_food[i] = new_entityfood({ texture = 0 }, x, 56)
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
      next_food[1].progress = (next_food[1].progress + 1) % 4
    end
  end

  if prev_note == 8 and cur_note == 1 then
    next_food[1] = next_food[2]
    next_food[1].x = 56
    next_food[2] = next_food[3]
    next_food[2].x = 80
    local f = cur_beat + 2
    if level[f] then
      next_food[3] = new_entityfood(level[f], 104, 56)
    else
      next_food[3] = new_entityfood({ texture = 0 }, 104, 56)
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
    rectfill(t_x - 1, t_y - 1, t_x + 1, t_y + t_h + 1, 3)
  else 
    line(t_x, t_y, t_x, t_y + t_h, 3)
  end
  
end

function drawnextfood() 
  for i = 1, 3 do
    if (next_food[i]) then
      spr(next_food[i].food.texture + next_food[i].progress, next_food[i].x, next_food[i].y)
    end
  end
end

function _draw()
	cls()
  local end_time = cur_time + ((bpm / 60) * 2)
  local end_beat = flr(end_time / crochet)
  local beat_offset = ((cur_time / crochet) - cur_beat)
  print("score: " .. score .. "\nbeat: " .. cur_beat .. "\nnote: " .. cur_note, 0, 127 - 24, 7)

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
  --line(t_x, t_y, t_x, t_y + t_h, 3)
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
010f00000c0430000000000000000c0430000000000000000c0430000000000000000c043000000c0000c0000c0430000000000000000c0430000000000000000c0430000000000000000c043000000c0000c000
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

