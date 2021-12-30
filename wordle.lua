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
        solution = self.word:sub(i,i)
      }
    end
    
    
  end
  
  
  return game
  
end



return wordle