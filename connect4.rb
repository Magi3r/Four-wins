=begin
    Four Wins by Magi3r

    If you find any issuses, please tell them on https://github.com/Magi3r/connect4
=end

class Field

    attr_accessor :sizeX, :sizeY, :field, :winCount

    def initialize
      initSize
      cls
      initWinCount
      #Setting vars to Inputs or default
      @field=Array.new((@sizeY+2)*(@sizeX+2), 0)
      self.printMe
    end

    def initSize
      system("color 0A")
      puts "How large the field should be?\nLeave blank for default size.(7x6)"
      print"\n (4 - 60) Length: "
      sizeX=gets.chop.to_i
      print "\n (4 - 60) Height: "
      sizeY=gets.chop.to_i
      if sizeX==0&&sizeY==0
        puts "Taking default size."
        @sizeX, @sizeY=7,6
      elsif sizeY>=4&&sizeX>=4&&sizeY<=60&&sizeX<=60
        @sizeX, @sizeY=sizeX, sizeY
      else
        system("color 0C")
        cls
        puts "ERROR - Unallowed Values!\nTaking default size."
        sleep 2
        system("color 0A")
        @sizeX, @sizeY=7,6
      end
    end

    def initWinCount
      puts "How many markers in a line you want to need to win?\nLeave blank for default size.(4)"
      @winCount=gets.chop.to_i
      case @winCount
      when @winCount>sizeX&&@winCount>sizeY
        cls
        puts "Winning not possible, taking default."
        sleep 2
        system("color 0A")
        @winCount=4
      when 0
        puts "Taking default."
        @winCount=4
      when 1
        puts "BORING!"
        while @winCount<2||(@winCount>@sizeX&&@winCount>@sizeY)
          puts "Just type another value!"
          @winCount=gets.chop.to_i
        end
      end
    end

    def printMe        #Customized printing of field
        cls
        puts "Needing "+@winCount.to_s+" in a line to win!"
        for count in 1..@sizeX do     #prints Numbers
          if count>=10
            print " "+count.to_s
          else
            print " "+count.to_s+" "
          end
        end

        puts "\n\n"

        for i in (@sizeX+3)..((@sizeX+2)*(@sizeY+2))-(@sizeX+3) do     #prints the Field
            if (i+1)%(sizeX+2)==0
                puts
                next
            end
            next if (i%(sizeX+2)==0)
            print " "+@field[i].to_s+" "
        end
        puts
        for count in 1..@sizeX do     #prints Numbers again
          if count>=10
            print " "+count.to_s
          else
            print " "+count.to_s+" "
          end
        end
    end
end

def checkX(f, i, player, win)
    count=0
    while count<win
        #puts i+count
        return false if f[i+count]!=player
        count+=1
    end
    return true
end

def checkY(f, sX, i, player, win)
    count=0
    while count<win
        #puts i+(2+sX)*count
        return false if f[i+(2+sX)*count]!=player
        count+=1
    end
    return true
end

def checkLeftDown(f, sX, i, player, win)
    count=0
    #puts "\nLeftDown:"
    while count<win
      #puts i-count+(sX+2)*count
      return false if f[i-count+(sX+2)*count]!=player
      count+=1
    end
    return true
end

def checkRightDown(f, sX, i, player, win)
    count=0
    #puts "\nRightDown:"
    while count<win
      #puts i+count+(sX+2)*count
      return false if f[i+count+(sX+2)*count]!=player
      count+=1
    end
    return true
end

def checkAll(f, x, i, p, win)
    return (checkX(f, i, p, win) || checkY(f, x, i, p, win) || checkLeftDown(f, x, i, p, win) || checkRightDown(f, x, i, p, win))
end

def getPos(x)
    loop do
        newPos = gets.to_i
        if newPos<=x && newPos>0
            return newPos
        else
           puts "Please type a value which is inside of the field!"
        end
    end
end

def turn(player, f)
    f.field[f.sizeX+1]
    puts "\nPlayer "+player.to_s
    pos=getPos(f.sizeX)
    if f.field[pos+f.sizeX+2]==0
        for i in 1..f.sizeY do
            if f.field[-2-(f.sizeX-pos)-(i*(2+f.sizeX))] == 0 then
                f.field[-2-(f.sizeX-pos)-(i*(2+f.sizeX))]= player
                f.printMe
                break
            end
        end
    else
        puts "This column is already full, please choose another!"
        turn(player, f)
    end

    if !win?(f)&&!unentschieden?(f)
        if player==1
            turn(2, f)
        else
            turn(1, f)
        end
    elsif unentschieden?(f)
        puts "No winner! The game ends in a draw."
    else
        puts "Player "+player.to_s+" wins!"
    end
end

def unentschieden?(f)
    for n in f.sizeX+4..2*f.sizeX+3
        return false if f.field[n]==0
    end
    return true
end

def win?(f)
    for i in 0..f.field.size

        case f.field[i]
        when 1
            return true if checkAll(f.field, f.sizeX, i, 1, f.winCount)
        when 2
            return true if checkAll(f.field, f.sizeX, i, 2, f.winCount)
        end

    end
    return false
end

def cls
	system "clear"	#Linux
	system "cls"	#Windows
end

def game
  cls
  f=Field.new
  turn(1, f)
  puts ""
  puts "Play again?"
  puts "Just answer in one word."
  print "\nDon't use punctations!\n"
  game if ["yes", "yeah", "of cause", "why not", "ok", "okay"].include?(gets.chop.downcase)
end

game
