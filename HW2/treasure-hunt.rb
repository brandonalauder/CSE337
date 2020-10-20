require "set"
class Console
  def initialize(player, narrator)
    @player   = player
    @narrator = narrator
  end

  def show_room_description
    @narrator.say "-----------------------------------------"
    @narrator.say "You are in room #{@player.room.number}."

    @player.explore_room

    @narrator.say "Exits go to: #{@player.room.exits.join(', ')}"
  end

  def ask_player_to_act
    actions = {"m" => :move, "s" => :shoot, "i" => :inspect }

    accepting_player_input do |command, room_number|
      @player.act(actions[command], @player.room.neighbor(room_number))
    end
  end

  private

  def accepting_player_input
    @narrator.say "-----------------------------------------"
    command = @narrator.ask("What do you want to do? (m)ove or (s)hoot?")

    unless ["m","s"].include?(command)
      @narrator.say "INVALID ACTION! TRY AGAIN!"
      return
    end

    dest = @narrator.ask("Where?").to_i

    unless @player.room.exits.include?(dest)
      @narrator.say "THERE IS NO PATH TO THAT ROOM! TRY AGAIN!"
      return
    end

    yield(command, dest)
  end
end

class Narrator
  def say(message)
    $stdout.puts message
  end

  def ask(question)
    print "#{question} "
    $stdin.gets.chomp
  end

  def tell_story
    yield until finished?

    say "-----------------------------------------"
    describe_ending
  end

  def finish_story(message)
    @ending_message = message
  end

  def finished?
    !!@ending_message
  end

  def describe_ending
    say @ending_message
  end
end

class Room
  attr_reader :number, :neighbors, :hazards
  attr_writer :number, :neighbors
  def initialize(number)
    @number = number
    @hazards = []
    @neighbors = []
  end

  def add(haz)
    @hazards << haz
  end

  def remove(haz)
    @hazards.delete(haz)
  end

  def empty?
    @hazards.empty?
  end

  def has?(haz)
    @hazards.include?(haz)
  end

  def neighbor(i)
    @neighbors.each { |neighbor| return neighbor if neighbor.number == i }
    nil
  end

  def connect(room)
    return if @neighbors.include?(room)

    @neighbors << room
    room.neighbors << self
  end

  def exits
    exitArr = []
    @neighbors.each { |neighbor| exitArr << neighbor.number }
    exitArr
  end

  def random_neighbor
    @neighbors.sample
  end

  def safe?
    return false unless @hazards.empty?

    @neighbors.each { |neighbor| return false unless neighbor.empty? }
    true
  end

end

class Cave
  attr_writer :rooms
  attr_reader :rooms

  def Cave.dodecahedron
    cave = Cave.new
    (1..20).each { |i| cave.rooms << Room.new(i) }
    cave.room(1).connect(cave.room(2))
    cave.room(1).connect(cave.room(5))
    cave.room(1).connect(cave.room(8))

    cave.room(2).connect(cave.room(3))
    cave.room(2).connect(cave.room(10))

    cave.room(3).connect(cave.room(4))
    cave.room(3).connect(cave.room(12))

    cave.room(4).connect(cave.room(5))
    cave.room(4).connect(cave.room(14))

    cave.room(5).connect(cave.room(6))

    cave.room(6).connect(cave.room(7))
    cave.room(6).connect(cave.room(15))

    cave.room(7).connect(cave.room(8))
    cave.room(7).connect(cave.room(17))

    cave.room(8).connect(cave.room(11))

    cave.room(9).connect(cave.room(10))
    cave.room(9).connect(cave.room(12))
    cave.room(9).connect(cave.room(19))

    cave.room(10).connect(cave.room(11))

    cave.room(11).connect(cave.room(20))

    cave.room(12).connect(cave.room(13))

    cave.room(13).connect(cave.room(14))
    cave.room(13).connect(cave.room(18))

    cave.room(14).connect(cave.room(15))

    cave.room(15).connect(cave.room(16))

    cave.room(16).connect(cave.room(17))
    cave.room(16).connect(cave.room(18))

    cave.room(17).connect(cave.room(20))

    cave.room(18).connect(cave.room(19))

    cave.room(19).connect(cave.room(20))
    cave
  end

  def initialize
    @rooms = []
  end

  def room(i)
    @rooms.detect { |room| room.number == i }
  end

  def random_room
    @rooms.sample
  end

  def move(haz, oldRoom, newRoom)
    return unless oldRoom.has?(haz)

    newRoom.add(haz) unless newRoom.has?(haz)

    oldRoom.remove(haz)
  end

  def add_hazard(haz, num)
    while @rooms.select { |e| e.has?(haz) }.count < num
      room = random_room
      room.add(haz) unless room.has?(haz)
    end
  end

  def room_with(haz)
    @rooms.each { |e| return e if e.has?(haz) }
  end

  def entrance
    @rooms.each { |e| return e if e.safe? }
    nil
  end
end

class Player
  attr_reader :room
  attr_writer :room
  @@senses = Hash.new
  @@encounters = Hash.new
  @@actions = Hash.new
  def initialize
    @room = nil

  end

  def sense(haz, &block)
    @@senses[haz] = block
  end

  def encounter(haz, &block)
    @@encounters[haz] = block
  end

  def action(haz, &block)
    @@actions[haz] = block
  end

  def enter(room)
    @room = room
    @room.hazards.each { |e| @@encounters[e].call }
  end

  def explore_room
    # @room.hazards.each { |e| @@senses[e].call }
    @room.neighbors.each { |e| e.hazards.each { |e1| @@senses[e1].call } }
  end

  def act(action, room)
    @@actions[action].call(room)
  end
end
#
# player = Player.new
# empty_room = Room.new(1)
# guard_room = Room.new(2)
# guard_room.add(:guard)
# bats_room = Room.new(3)
# bats_room.add(:bats)
# room4 = Room.new(4)
# sensed = Set.new
# encountered = Set.new
# empty_room.connect(guard_room)
# empty_room.connect(bats_room)
# player.sense(:bats) do
#   sensed.add("You hear a rustling")
# end
# player.sense(:guard) do
#   sensed.add("You smell something terrible")
# end
# player.encounter(:guard) do
#   encountered.add("The guard killed you")
# end
# player.encounter(:bats) do
#   encountered.add("The bats whisked you away")
# end
# player.action(:move) do |destination|
#   player.enter(destination)
# end
# player.enter(empty_room)
# player.explore_room
# puts sensed
#
# player = Player.new
# player.enter(bats_room)
# puts encountered == Set["The bats whisked you away"]
#
# player = Player.new
# player.act(:move, guard_room)
# puts player.room.number == guard_room.number
# puts encountered == Set["The guard killed you"]
# puts sensed.empty? == true
