# rotation decoder
require 'set'

class CircularArray < Array
  def [](i)
    return super if i < length
    return self[i%length]
  end
end

class String
  def to_a
    split('')
  end
end

class String
  def score(wordlist)
    split.inject(0) { |total, word| total += wordlist.member?(word) ? 1 : 0 }
  end
end

words = Set.new
File.open('enable1.txt', 'r') do |file|
  file.readlines.map(&:chop).each { |line| words.add(line) }
end

alphabet = CircularArray.new(('a'..'z').to_a)
alph_set = Set.new()
# Makes a Hash from an Array 'x' of two-element Arrays with Hash[x]
# Just another example of how Ruby is awesome
alph_pos = Hash[alphabet.zip(alphabet.each_index)]

ARGV.length.times do
  message_arr = ARGV.shift.downcase.to_a
  candidates = []
  25.times do |shft|
    cand = message_arr.map { |char| char == ' ' ? ' ' : alphabet[shft+1+alph_pos[char]] }.join
    candidates.push(cand)
  end
  puts "Calculating most likely decoding..."
  puts candidates.sort_by { |cand| cand.score(words) }.last
end