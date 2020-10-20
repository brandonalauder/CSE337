class Array
  alias old []
  alias oldMap map
  def [](index)
    return '\0' if index >= length || index < -length

    old(index)
  end

  def map(seq = nil)
    newArr = []
    if seq.nil?
      each_with_index { |x, i| newArr[i] = yield(x) }
    else
      seq.each_with_index { |x, i| newArr[i] = yield(self[x]) if x < length }
    end
    newArr
  end
end


# a	=	[1, 2, 34, 5]
# puts a.map(2..4)	{	|i|	i.to_f}
# puts a.map	{	|i|	i.to_f}

b	=	["cat","bat","mat","sat"]
# puts b[-1]
# puts b[5]
# puts b.map(2..10)	{	|x|	x[0].upcase	+	x[1,x.length]	}
# puts b.map(2..4) {	|x|	x[0].upcase	+	x[1,x.length]	}
# puts b.map(-3..-1) {	|x|	x[0].upcase	+	x[1,x.length]	}
# puts (b.map	{	|x|	x[0].upcase	+	x[1,x.length]	})
# puts b[1]