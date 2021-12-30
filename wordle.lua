local wordle = {}

function wordle.clone(orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[wordle.clone(orig_key, copies)] = wordle.clone(orig_value, copies)
      end
      setmetatable(copy, wordle.clone(getmetatable(orig), copies))
    end
  else
    copy = orig
  end
  return copy
end



function wordle.new(word,wordlist,newconfig)
  newconfig = newconfig or {}
  local game = {
    word = word,
    wordlist = wordlist,
    config = {
      guesses = 6,
      wordlength = 5,
      checkwords = true,
      hardmode = false
    },
    known = {
      grey = {},
      goodletters = {},
      greens = {},
      lastgoodletters = {},
      lastgreens = {},
      lastgrey = {}
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
    strguess = string.lower(strguess)
    
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
    
    if self.config.checkwords then
      local goodword = false
      for i,v in ipairs(self.wordlist) do
        if strguess == v then
          goodword = true
        end
      end
      if not goodword then
        output.t = "notaword"
        return output
      end
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
      end
    end
    
    for i,v in ipairs(newguess) do
      if v.color ~= 2 then
        if letterbank[v.letter] then
          if letterbank[v.letter] ~= 0 then
            v.color = 1
            letterbank[v.letter] = letterbank[v.letter] - 1
          end
        end
      end
    end
    
    
    self.known.lastgoodletters = wordle.clone(self.known.goodletters)
    self.known.lastgreens = wordle.clone(self.known.greens)
    self.known.lastgrey = wordle.clone(self.known.grey)
    
    self.known.goodletters = {}
    self.known.greens = {}
      
      
    for i,v in ipairs(newguess) do
      if v.color == 2 then
        table.insert(self.known.greens,{i=i,letter=v.letter})
        if not self.known.goodletters[v.letter] then
          self.known.goodletters[v.letter] = 1
        else
          self.known.goodletters[v.letter] = self.known.goodletters[v.letter] + 1
        end
      elseif v.color == 1 then
        if not self.known.goodletters[v.letter] then
          self.known.goodletters[v.letter] = 1
        else
          self.known.goodletters[v.letter] = self.known.goodletters[v.letter] + 1
        end
      else
        if not self.known.grey[v.letter] then
          self.known.grey[v.letter] = true
        end
      end
      
    end
    
    if self.config.hardmode then
      for i,v in ipairs(newguess) do
        if self.known.lastgrey[v.letter] then
          output.t = 'hardmodefail'
          output.t2 = 'knowngrey'
          output.t3 = v.letter
          
          self.known.grey = wordle.clone(self.known.lastgrey)
          self.known.goodletters = wordle.clone(self.known.lastgoodletters)
          self.known.green = wordle.clone(self.known.lastgreen)
          
          return output
        end
        
      end
      
      for k,v in pairs(self.known.lastgoodletters) do
        
        local failed = false
        
        if not self.known.goodletters[k] then
          failed = true
        elseif self.known.goodletters[k] < v then
          failed = true
        end
        
        
          
        if failed then
          output.t = 'hardmodefail'
          output.t2 = 'notenoughyellow'
          output.t3 = k
          output.t4 = self.known.goodletters[k] or 0
          output.t5 = v
          
          self.known.grey = wordle.clone(self.known.lastgrey)
          self.known.goodletters = wordle.clone(self.known.lastgoodletters)
          self.known.green = wordle.clone(self.known.lastgreen)
          
          return output
        end
      end
      
    end
      
    
    output.guess = newguess
    table.insert(self.guesses,newguess)
    if greens == self.config.wordlength then
      output.t = 'complete'
    else
      if #self.guesses >= self.config.guesses then
        output.t = 'gameover'
      else
        output.t = 'incomplete'
      end
    end
    
    
    
    return output
    
  end
  
  
  
  return game
  
end



return wordle