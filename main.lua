-- wordle in lua

sgbwords = {}
print('loading words...')
for line in io.lines('sgb-words.txt') do
  table.insert(sgbwords,line)
end
print('done!')

math.randomseed( os.time() )

function get_random_word()
  return sgbwords[math.random(1,#sgbwords)]
end


wordle = require('wordle')

game = wordle.new(get_random_word(),sgbwords)
while true do
  local newguess = io.read()
  output = game:guess(newguess)
  if output.t == 'incomplete' then
    local resultstr = ''
    for i,v in ipairs(output.guess) do
      if v.color == 2 then
        resultstr = resultstr .. 'G'
      elseif v.color == 1 then
        resultstr = resultstr .. 'y'
      else
        resultstr = resultstr .. '.'
      end
    end
    print(resultstr)
  end
  print(output.t)
end
