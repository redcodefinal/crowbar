# Replaces symbols
class Mutator::Replacer < Mutator
  @regex : Regex
  @generator : Generator

  def initialize(crowbar, @generator = Generator::Decimals.new(crowbar), @regex = Constants::Regex::IN_QUOTES)
    super crowbar
  end

  def mutate(input) : String
    # detect symbols in text
    matches = input.scan(@regex)

    effect = self.crowbar.noise.height_float(self.crowbar.iteration, self.crowbar.iteration, 1)
    shuffled_matches = self.crowbar.noise.shuffle(self.crowbar.iteration, matches)
    used_matches = shuffled_matches[0..(matches.size*effect).to_i].sort{|a,b| a.begin.as(Int32) <=> b.begin.as(Int32)}

    offset = 0
    output = input
    used_matches.each do |match|
      start = match.begin.as(Int32) + offset
      finish = match.end.as(Int32) + offset
      range = (start...finish)
      replacement = @generator.make
      output = output.sub(range, replacement)
      offset += replacement.size - range.size
    end
    output
  end
end