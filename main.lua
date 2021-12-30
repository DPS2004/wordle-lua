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

game:guess('hello')
