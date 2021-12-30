local wordle = {}


function wordle.new(word,wordlist,newconfig)
  newconfig = newconfig or {}
  local game = {
    word = word,
    wordlist = wordlist,
    config = {
      guesses = 6,
      wordlength = 5,
    },
    guesses = {}
  }
  
  for k,v in pairs(newconfig) do
    game.config[k] = v
  end
  
  function game:tellword()
    print(self.word)
  end
  
  function game:guess(strguess)
    
    local output = {}
    
    if #self.guesses >= self.config.guesses then
      output.t = "nomoreguesses"
      return output
    end
    
    if #strguess < self.config.wordlength then
      output.t = "toofew"
      return output
    end
    
    if #strguess > self.config.wordlength then
      output.t = "toomany"
      return output
    end
    --if you have gotten here, it is a valid guess.
    
    
    local newguess = {}
    
    for i=1,#strguess do
      newguess[i] = {
        letter = strguess:sub(i,i),
        solution = self.word:sub(i,i),
        color = 0 -- 0 is grey, 1 is yellow, 2 is green
      }
    end
    
    local letterbank = {}
    
    for i=1,#self.word do
      local c = self.word:sub(i,i)
      if not letterbank[c] then
        letterbank[c] = 1
      else
        letterbank[c] = letterbank[c] + 1
      end
    end
    
    local greens = 0 
    
    for i,v in ipairs(newguess) do
      if v.letter == v.solution then
        greens = greens + 1
        v.color = 2
        letterbank[v.letter] = letterbank[v.letter] - 1
      else
        if letterbank[v.letter] then
          if letterbank[v.letter] ~= 0 then
            v.color = 1
            letterbank[v.letter] = letterbank[v.letter] - 1
          end
        end
      end
      
    end
    
    output.guess = newguess
    table.insert(self.guesses,newguess)
    if greens == self.config.wordlength then
      output.t = 'complete'
    else
      output.t = 'incomplete'
    end
    
    return output
    
  end
  
  
  
  return game
  
end



return wordle