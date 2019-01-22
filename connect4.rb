=begin
    Four Wins by Magi3r

    This Program should work, only the win-condition is not finished.
    A player wins instantly when he places his 4th marker in a row or column,
    no matter if there are seperated or together.

    If you find any issuses, please tell them on https://github.com/Magi3r/Four-wins

    TO-DO:
    - fix diagonal winning
=end

class Field

    attr_accessor :sizeX, :sizeY, :field

    def initialize(sizeX=7, sizeY=6) #Setting vars to Inputs or default
        @sizeX=sizeX
        @sizeY=sizeY
        @field=Array.new((@sizeY+2)*(@sizeX+2), 0)
        self.printMe
    end


    def printMe        #Customized printing of field
        sizeX=@sizeX
        cls
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

def checkX(f, i, player)
    count=0
    while count<4
        #puts i+count
        return false if f[i+count]!=player
        count+=1
    end
    return true
end

def checkY(f, sX, i, player)
    count=0
    while count<4
        #puts i+(2+sX)*count
        return false if f[i+(2+sX)*count]!=player
        count+=1
    end
    return true
end

def checkLeftDown(f, sX, i, player)
    count=0
    while count<4
        #puts i-count+sX*count
        return false if f[i-count+sX*count]!=player
        count+=1
    end
    return true
end

def checkRightDown(f, sX, i, player)
    count=0
    while count<4
        #puts i+count+sX*count
        return false if f[i+count+sX*count]!=player
        count+=1
    end
    return true
end

def checkAll(f, x, i, p)
    return (checkX(f, i, p) || checkY(f, x, i, p) || checkLeftDown(f, x, i, p) || checkRightDown(f, x, i, p))
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

def win?(f)     #Hier entstehen FEHLER
    for i in 0..f.field.size

        case f.field[i]
        when 1
            return true if checkAll(f.field, f.sizeX, i, 1)
        when 2
            return true if checkAll(f.field, f.sizeX, i, 2)
        end

    end
    return false
end

def cls
	system "clear"	#Linux
	system "cls"	#Windows
end

playAgain=true

while playAgain
  cls
  system("color 0A")
  puts "How large the field should be?\nLeave blank for default size."
  print"\n (max 60) Length: "
  sizeX=gets.chop.to_i
  print "\n (max 60) Height: "
  sizeY=gets.chop.to_i

  if sizeX==0&&sizeY==0
    puts "Taking default parameters."
    sleep 1
    f=Field.new
  elsif sizeY>=4&&sizeX>=4&&sizeY<=60&&sizeX<=60
    f=Field.new(sizeX, sizeY)
  elsif sizeY<=4||sizeX<=4||sizeY>=60||sizeX>=60
    system("color 0C")
    for i in 1..3 do
      cls
      puts "ERROR - Values do not fit!\nTaking default parameters."
      print 4-i
      sleep 1
    end
    system("color 0A")
    f=Field.new
  end

  turn(1, f)
  puts ""
  puts "Play again?"
  puts "Just answer in one word."
  print "\nDon't use punctations!\n"
  playAgain=["yes", "yeah", "of cause", "why not", "ok", "okay"].include?(gets.chop.downcase)
end
