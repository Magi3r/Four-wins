=begin
	Four Wins by Magi3r
	
	This Program should work, only the win-condition is not finished.
	A player wins instantly when he places his 4th marker in a row or column,
	no matter if there are seperated or together.
	
	If you find any issuses, please tell them
	
	TO-DO:
	- fix win-condition
=end

class Field
	
	attr_accessor :sizeX, :sizeY, :field
	
	@sizeX = 0
	@sizeY = 0
	@field = []
	
	def initialize(sizeX=7, sizeY=6)
		@sizeX=sizeX
		@sizeY=sizeY
		@field=Array.new(@sizeY) {Array.new(@sizeX, 0)}
		self.printField
	end
	
	def printField		#Cusstomized printing of field
		system("cls")
		for count in 1..@sizeX do
			print " #{count} "
		end
		for x in 0..@sizeY-1 do
			print "\n#{@field[x]}"
		end
		puts ""
		for count in 1..@sizeX do
			print " #{count} "
		end
		puts "\n"
	end

	def turn(player)
		puts "\nPlayer #{player}"
		pos=getPos
		if @field[0][pos]==0
		    for i in 0..@sizeY-1 do
			    if @field.reverse[i][pos] == 0 then
				    @field.reverse[i][pos] = player
				    self.printField
				    break
			    end
		   end
		else
		    puts "This column is already full, please choose another!"
			self.turn(player)
		end
	end
	
	def getPos
		loop do
			newPos = gets.to_i
			if newPos<=@sizeX && newPos>0
				return newPos-1
			else
				puts "Please type a value which is inside of the field!"
			end
		end
	end
	
end

def win?(field, sizeX, sizeY)
	
	for y in 0..sizeY do
		
		px1, px2,=0,0
  		for x in 0..sizeX do
		
			case field[y][x]
			when 1
				px1+=1
				return true if px1>= 4
			when 2
				px2+=1
				return true if px2 >= 4
			end
			
		end
	end
	
	for x in 0..sizeX do
		
		py1, py2,=0,0
  		for y in 0..sizeY do
		
			case field[y][x]
			when 1
                py1+=1
				return true if py1>=4
			when 2
                py2+=1
				return true if py2>=4
			end
			
		end
	end
	return false
end

def winner(r)
	return 1+r%2
end

round=1

system("cls")
system("color 0A")
puts "How large the field should be?\nFirst enter the number of columns, then the number of rows!\nLeave blank for default size."
sizeX, sizeY=gets.chop.to_i, gets.chop.to_i
if sizeY>=4&&sizeX>=4&&sizeY.integer?&&sizeX.integer?
	f=Field.new(sizeX, sizeY)
elsif sizeX==0&&sizeY==0
	puts "Taking default parameters."
	sleep 1
	f=Field.new
else
	system("color 0C")
	for i in 1..3 do
		system("cls")
		puts "ERROR - Values too small!\nTaking default parameters."
		print 4-i
		sleep 1
	end
	system("color 0A")
	f=Field.new
end

while !win?(f.field, f.sizeX-1, f.sizeY-1) do
	if round%2 == 1
		f.turn(1)
	else
		f.turn(2)
	end
	round+=1
end
puts "Player #{winner(round)} wins in #{round/2} turns!"
sleep 3
#system("exit")
