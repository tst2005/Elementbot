--Programmed in Lua 5.1.5 programming language.
--This program uses the LuaSocket Library. http://w3.impa.br/~diego/software/luasocket/
account = {name = "StandUser", rank = "E.", cuname = "StandUser", auth = false, pass = "Placehold3892"}
accounts = {}
accounts[3001] = {}
accounts[3001].name = "ERROR"
tell = {sender = "Elementbot", aerial = "Elementbot", message = "Default message. Obviously, something went wrong here!", date = "Error", read = true}
tells = {}
yell = {sender = "Elementbot", aerial = "Elementbot", message = "Default message. Obviously, something went wrong here!", date = "Error"}
yells = {}
authrep = {perp = "Perpetrator", time = os.date(), hname = "ERROR", accname = "StandUser", read = false}
authreps = {}
Command = {}
lmess = {}
lseen = {}
require("socket")
http = require("socket.http")
rank = {}
rank["A+"] = 900; rank["A."] = 800; rank["B+"] = 700; rank["B."] = 600; rank["C+"] = 500; rank["C#"] = 400; rank["C."] = 300; rank["D."] = 200; rank["E."] = 100; rank["F."] = 1
rp = false
messind = {}
tokens = {}
ttime,rtime = 0

function checkin(user,channel)
	for k,v in pairs(tells) do
		print("[C] "..tells[k].aerial.. " to "..user)
		if tells[k].aerial == user then
			s:send("PRIVMSG #"..channel.." :"..user..": "..tells[k].sender.." left a message for you at "..tells[k].date..": "..tells[k].message.."\r\n\r\m")
			tells[k].read = true
		end
	end
	tellwrite("Tells",tells)
	tellread("Tells",tells)
end
function seenwrite()
	local seefile = io.open("LSeenFF.txt","w")
	for k,v in pairs(lseen) do
		seefile:write(v.."\n")
	end
	seefile:write("--end>>\n")
	seefile:close()
end
function seenread()
	local seefile = io.open("LSeenFF.txt","r")
	local c = 0
	repeat
		c = c + 1
		lseen[c] = seefile:read('*l')
	until lseen[c] == "--end>>"
	lseen[c] = nil
	seefile:close()
end
function decthex(inp)
    local b,k,out,i,d = 16,"0123456789ABCDEF","",0
    while inp > 0 do
        i = i + 1
        inp,d = math.floor(inp/b),math.mod(inp,b) + 1
        out = string.sub(k,d,d)..out
    end
    return out
end
function tobool(var) --Turns string to boolean.
	if var == "true" then
		local var = true
	elseif var == "false" then
		local var = false
	else
		local var = nil
	end
	return var
end
function tellread(type,typ) --Reads all tells into memory
	local wfile = io.open(type.. "FF.txt", "r")
	for i = 1,3000,1 do
		typ[i] = nil
	end
	repeat
		local st = wfile:read('*l')
		if st:match("%-%-.+<<") then
			aer = st:match("%-%-(.+)<<")
			message = wfile:read('*l')
			send = wfile:read('*l')
			dat = wfile:read('*l')
		for i = 1,3000,1 do
			if typ[i] == nil then
				typ[i] = tell:create(aer,send,message,dat,typ[i])
			break end 
		end
	end
	until st:match("%-%-end>>")
end
function tellwrite(type,typ) --Writes tells to file.
	local wfile = io.open(type.. "FF.txt", "w")
	for k,v in pairs(tells) do
		print(" ")
		print(k..".			"..tostring(v))
		for ke,va in pairs(tells[k]) do
			print(ke..".		"..tostring(va))
		end
	end
	for k,v in pairs(typ) do
		if not typ[k].read then
			wfile:write("--"..typ[k].aerial.."<<\n")
			wfile:write(typ[k].sender.."\n")
			wfile:write(typ[k].message.."\n")
			wfile:write(typ[k].date.."\n")
		end
	end
	wfile:write("--end>>")
	wfile:close()
	tellread("Tells",tells)
end
function tell.create(self,aerial,sender,message,date,o) --Create a tell.
	local o = o or {aerial = aerial, sender = sender, message = message, date = os.date(), read = false}
	setmetatable(o, self)
	self.__index = self
	return o
end
function Command.create(self,n)
	local o = {name = n}
	setmetatable(o, self)
	self.__index = self
	return o
end
function Command.execute(self,channel,sender,args)
	message = "user " .. sender .. " ran command " .. self.name .. " in the channel " .. channel .. " with	 arguements " .. args.. ". This is default implementation."
	print("[+] "..message)
end
function authrep.create(self,perp,uname,time,hname,o)
	local o = o or {perp = perp, time = time, accname = uname, hname = hname, read = false}
	setmetatable(o,self)
	self.__index = self
	return o
end
Appecomm = Command:create(Appecomm)
Showcomm = Command:create(Showcomm)
Tellcomm = Command:create(Tellcomm)
Deficomm = Command:create(Deficomm)
Calccomm = Command:create(Calccomm)
Synocomm = Command:create(Synocomm)
Randcomm = Command:create(Randcomm)
Bytecomm = Command:create(Bytecomm)
Hexacomm = Command:create(Hexacomm)
Seencomm = Command:create(Seencomm)
Intrcomm = Command:create(Intrcomm)
Evalcomm = Command:create(Evalcomm)
Mathcomm = Command:create(Mathcomm)
function Evalcomm:execute(channel,inp)
	inp = inp:gsub("inf","{{{{")
	inp = inp:gsub("pi","{{}{}}}")
	inp = inp:gsub("%a","")
	inp = inp:gsub("{{{{","math.huge")
	inp = inp:gsub("{{}{}}}","math.pi")
	inp = inp:gsub("=","")
	inp = inp:gsub("%[","")
	inp = inp:gsub("%]","")
	print("[*] Result: "..inp)
	local y = loadstring("d = "..inp.." ; return d")
	if pcall(y) then
		s:send("PRIVMSG #"..channel.." :"..y().."\r\n\r\n")
	else
		s:send("PRIVMSG #"..channel.." :ERROR: Invalid syntax!\r\n\r\n")
	end
end
function Mathcomm:execute(channel,oper,num)
	num = num:gsub(" ","")
	if not tonumber(num) then
		s:send("PRIVMSG #"..channel.." :ERROR: Please enter a NUMBER!\r\n\r\n")
	elseif tonumber(num) then
		local oper = string.lower(oper)
		print("[C] "..oper)
		local out = 0
		if oper == "abs" then
			out = math.abs(num)
		elseif oper == "cos" then
			out = math.cos(num)
		elseif oper == "tan" then
			out = math.tan(num)
		elseif oper == "sin" then
			out = math.sin(num)
		elseif oper == "acos" then
			out = math.acos(num)
		elseif oper == "asin" then
			out = math.asin(num)
		elseif oper == "ceil" then
			out = math.ceil(num)
		elseif oper == "floor" then
			out = math.floor(num)
		elseif oper == "tanh" then
			out = math.tanh(num)
		elseif oper == "cosh" then
			out = math.cosh(num)
		elseif oper == "sinh" then
			out = math.sinh(num)
		elseif oper == "deg" then
			out = math.deg(num)
		elseif oper == "rad" then
			out = math.rad(num)
		elseif oper == "exp" then
			out = math.exp(num)
		elseif oper == "log" then
			out = math.log(num)
		elseif oper == "logt" then
		out = math.log10(num)
		elseif oper == "sqrt" then
			out = math.sqrt(num)
		else
			out = "ERROR: Math operation not recognised!"
		end
		s:send("PRIVMSG #"..channel.." :"..out.."\r\n\r\n")
	end
end
function Intrcomm:execute(channel)
	s:send("PRIVMSG #"..channel.." :I am an IRC bot written in the Lua 5.1.5 programming language by Fiestaguy. I use the LuaSocket library. Find info about me at http://escaperestart.com/forum/threads/elementbot-blocktopia-irc-bot.17628/ . Changelogs and Sourcecode can be found at http://http://thebes.openshells.org/~fiestasheep/\r\n\r\n")
end
function Seencomm:execute(pers,channel)
	for k,v in pairs(lseen) do
		if v:match("(.+)////.+||||.+") == pers then
			if v:match(".+////.+||||(.+)") == "Nilninlnklfgdkhijoihreiuwhigger48397834" then
				s:send("PRIVMSG #"..channel.." :"..pers.." was last seen at "..v:match(".+////(.+)||||.+").."\r\n\r\n")
				return 0
			else
				s:send("PRIVMSG #"..channel.." :"..pers.." was last seen at "..v:match(".+////(.+)||||.+").." saying '"..v:match(".+////.+||||(.+)").."'\r\n\r\n")
				return 0
			end
		end
	end
	s:send("PRIVMSG #"..channel.." :No records of "..pers.." could be found.\r\n\r\n")
end
function Hexacomm:execute(n,channel)
	if not tonumber(n) then
		s:send("PRIVMSG #"..channel.." :Please enter a NUMBER!\r\n\r\n")
	else
		out = decthex(tonumber(n))
    	s:send("PRIVMSG #"..channel.." :Decimal number "..n.." has a hexadecimal value of 0x"..out.."\r\n\r\n")
	end
end
function Bytecomm:execute(b,channel)
	local let,esc = {},{}
	local c = 0
	for k in b:gmatch("\\%a") do
		c = c + 1
		esc[c] = string.byte(k)
		b = b:gsub(k,"")
	end
	local c = 0
	for k in b:gmatch(".") do
		c = c + 1
		let[c] = string.byte(k)
	end
	if let[1] then
		s:send("PRIVMSG #"..channel.." :Letters in-order: "..table.concat(let," ").."\r\n\r\n")
	end
	if esc[1] then
		s:send("PRIVMSG #"..channel.." :Escape-Sequences detected: "..table.concat(esc," ").."\r\n\r\n")
	end
end
function Synocomm:execute(channel,word)
	local d = {}
	local f = assert(http.request("http://www.thesaurus.com/browse/" ..word))
	local ffile = io.open("dump.txt", "w")
	ffile:write(tostring(f))
	ffile:close()
	local ffile = io.open("dump.txt", "r")
	local stopsearch = 0
	repeat
		local f = ffile:read('*l')
		stopsearch = stopsearch + 1
		if not f then f = tostring(f) end
	until f:match('<div id="synonym_of_synonyms_%d" class="box syn_of_syns">') or stopsearch >= 6000
	if stopsearch >= 6000 then s:send("PRIVMSG #" ..channel.. " :Word not found. Are you sure you typed it correctly?\r\n\r\n") else
		local count = 0
		local ind = {}
		repeat
			f = ffile:read('*l')
			if not f then f = tostring(f) end
			print(f)
			if f:match('<a href="http://www.thesaurus.com/browse/.+">') then
				count = count + 1
				if not f then f = tostring(f) end
				ind[count] = f:match('<a href="http://www.thesaurus.com/browse/(.+)">')
			end
		until f:match('<div class="link">') or stopsearch >= 6000
		if stopsearch >= 6000 then s:send("PRIVMSG #" ..channel.. " :Word not found. Are you sure you typed it correctly?\r\n\r\n") else
			local outp = ''
			local firstw = false
			for k,v in pairs(ind) do
				if not firstw then
					outp = outp .. v
					firstw = true
				else
					outp = outp .. ", " ..v
				end
			end
			outp = outp:gsub("%%20"," ")
			outp = outp:gsub("%%27","'")
			s:send("PRIVMSG #"..channel.. " :Synonyms for " ..tostring(word).. ": " ..tostring(outp).. "\r\n\r\n")
		end
	end
end
function Randcomm:execute(channel,min,max)
	print("[C] "..min.." "..max)
	if tonumber(min) >= tonumber(max) then
		s:send("PRIVMSG #"..channel.." :Error: Second number must be bigger than the first!\r\n\r\n")
	elseif tonumber(min) > 1000000 or tonumber(max) > 1000000 then
		s:send("PRIVMSG #"..channel.." :Error: Numbers must not be bigger than 1M! (1000000)\r\n\r\n")
	else
		math.randomseed(os.time())
		math.random(tonumber(min),tonumber(max)); math.random(tonumber(min),tonumber(max)); math.random(tonumber(min),tonumber(max))
		local out = math.random(tonumber(min),tonumber(max))
		s:send("PRIVMSG #"..channel.." :"..out.."\r\n\r\n")
	end
end
function Calccomm:execute(channel,sum)
	local sum = sum:gsub(":","/")
	local sum = sum:gsub("%*%*","^")
	--MAGIC CHARACTERS: ( ) . % + - * ? [ ^ $
	if input:match("%d+ ?%+*%-*%^*/*%(*%)*%** ?%d") and not input:match("%a+") then
		print("[+] Valid sum. Accepted")
		print("[+]".. input)
		s:send("PRIVMSG #"..channel.. " :"..assert(loadstring(sum)())..".\r\n\r\n")
	else
		print("[+] Invalid sum. Denied")
		print("[+]".. input)
		s:send("PRIVMSG #"..channel.. " :ERROR: Invalid arithmetic operators. Valid operators: +, -, *, ^ (**), / (:), (, ).\r\n\r\n")
	end
end
function Deficomm:execute(channel,word)
    local f = http.request("http://www.dictionary.reference.com/browse/" ..word)
    local ffile = io.open("dump.txt", "w")
    ffile:write(f)
    ffile:close()
    local ffile = io.open("dump.txt", "r")
    local f = ffile:read('*all')
    local typ = string.match(f, '<span class="dbox%-pg">(.-)</span> </header>')
    local stopsearch = 0
    ffile:close()
    local ffile = io.open("dump.txt", "r")
    repeat
        q = ffile:read('*l')
        stopsearch = stopsearch + 1
        if q == nil then q = tostring(q) end
    until string.match(q, '<span class="def%-number">1%.</span>') or stopsearch == 3000
    if stopsearch >= 3000 then s:send("PRIVMSG #"..channel.. " :Word not found. Are you sure you typed it correctly?\r\n\r\n") else
        ffile:read('*l')
        local word = tostring(word)
        typ = tostring(typ)
        conte = tostring(conte)
        conte = ffile:read('*l')
        conte = conte:gsub('<.->', '')
      	typ = typ:gsub('<.->','')
        conte = tostring(conte)
        print("[+] " ..word..": "..typ..": "..conte)
        s:send("PRIVMSG #"..channel.. " :"..word..": "..typ..": "..conte.."\r\n\r\n")
    end
end
function Appecomm:execute(chan,sender,target,dest)
	local mtake = lmess[sender]
	if lmess[sender] == nil then
		s:send("PRIVMSG #"..chan.." :ERROR.\r\n\r\n")
	else
		local dtake = mtake:gsub(target,dest)
		if dtake == mtake then
			s:send("PRIVMSG #"..chan.." :Word not found.\r\n\r\n")
		else	
			s:send("PRIVMSG #"..chan.. " :"..sender.. " meant to say: "..dtake.."\r\n\r\n")
		end
	end
end
function Tellcomm:execute(channel,sender,aerial,message)
	for i = 1,3000 do
		if not tells[i] then
			tells[i] = tell:create(aerial,sender,message,os.date(),tells[i])
			s:send("PRIVMSG #"..channel.. " :I'll be sure to let them know!\r\n\r\n")
			break
		end
	end
	tellwrite("Tells",tells)
	tellread("Tells",tells)
end
s = socket.tcp()
assert(s:connect("irc.freenode.net", 6665)) --Connect to IRC.FREENODE.NET
s:send("NICK Elementbot\r\n") --Nickname
s:send("USER Elementbot 0 0 :Elementbot\r\n") --Connection details.
tellread("Tells",tells)
logging = true
logfile = io.open("LogsFF.txt","W")
stime = os.date("*t")
while true do --Connection loop.
    receive = assert(s:receive('*l'))
    if logfile then logfile:write(receive .. "\n") end
    if string.match(receive, "PING :(.+)") ~= nil then --Checks for server pings
        p = string.match(receive, "PING :(.+)")
		print("[+] Received server ping: " ..p)
        s:send("PONG :" ..p.. "\r\n\r\n")
        print("[+] Sent server pong: " ..p)
		break
	end
end
print("[PRESS ENTER AFTER FIRST PING]") --Now's your chance!
io.stdin:read('*l')
s:send("PRIVMSG Nickserv :identify <>\r\n\r\n") --Identify with nickserv.
s:send("JOIN #elementbot\r\n\r\n") --Join main channel.
--s:send("JOIN #blocktopia\r\n\r\n") --Disabled for development.
s:send("PRIVMSG #elementbot :Elementbot v1.5.4 (STABLE)\r\n\r\n") --First testmessage.
seenread()
while true do
	local messcount = 0
	receive = assert(s:receive('*l'))
	dtime = os.date("*t")
	if receive:match(":(.+)!.+ PRIVMSG #?(.+) :.+") then
		sender,hostn,chan = receive:match(":(.+)!(.+) PRIVMSG #?(.+) :.+")
	end
	print(tostring("[*] " ..receive))
	if receive:match(":.+ PRIVMSG #.+ :%.syn .-") then Synocomm:execute(chan,receive:match(":.+ PRIVMSG #.+ :%.syn (.+)")) end
	if receive:match(":.+ PRIVMSG #.+ :%.red .+/.+") then Appecomm:execute(chan,sender,receive:match(":.+ PRIVMSG #.+ :%.red (.+)/.+"),receive:match(":.+ PRIVMSG #.+ :%.red .+/(.+)")) end
	if receive:match(":.+ PRIVMSG #.+ :%.def .-") then Deficomm:execute(chan,receive:match(":.+ PRIVMSG #.+ :%.def (.+)")) end
	if receive:match(":.+ PRIVMSG #.+ :%.seen .+") then Seencomm:execute(receive:match(":.+ PRIVMSG #.+ :%.seen (.+)"),chan) end
	if receive:match(":.+ PRIVMSG #.+ :%.hex %d+") then Hexacomm:execute(receive:match(":.+ PRIVMSG #.+ :%.hex (%d+)"),chan) end
	if receive:match(":.+ PRIVMSG #.+ :%.byte .+") then Bytecomm:execute(receive:match(":.+ PRIVMSG #.+ :%.byte (.+)"),chan) end
	if receive:match(":.+ PRIVMSG #.+ :%.random %d+/%d+") then Randcomm:execute(chan,receive:match(":.+ PRIVMSG #.+ :%.random (%d+)/%d+"),receive:match(":.+ PRIVMSG #.+ :%.random %d+/(%d+)")) end
	if receive:match(":.+ PRIVMSG #.+ :%.eval .+") then Evalcomm:execute(chan,receive:match(":.+ PRIVMSG #.+ :%.eval (.+)")) end
	if receive:match(":.+ PRIVMSG #.+ :%.%?") then Intrcomm:execute(chan) end
	if receive:match(":.+ PRIVMSG #.+ :%.math .- .+") then Mathcomm:execute(chan,receive:match(":.+ PRIVMSG #.+ :%.math (.-) .+"),receive:match(":.+ PRIVMSG #.+ :%.math .- (.+)")) end
	if receive:match(":.+ PRIVMSG #?.+ :%.tell .- .+") then Tellcomm:execute(chan,sender,receive:match(':.+ #?.+ :%.tell (.-) .+'),receive:match(':.+ #?.+ :%.tell .- (.+)')) end
	if receive:match(":.+ PRIVMSG #.+ :s/.+/.+") then Appecomm:execute(chan,sender,receive:match(":.+ PRIVMSG #.+ :s/(.+)/.+"),receive:match(":.+ PRIVMSG #.+ :s/.+/(.+)")) end
 	if string.match(receive, "PING :(.+)") then --Checks for server pings
        p = string.match(receive, "PING :(.+)")
		print("[+] Received server ping: " ..p)
        s:send("PONG :" ..p.. "\r\n\r\n")
        print("[+] Sent server pong: " ..p)
	end
	if receive:match(":.+!.+ PRIVMSG #.+ :.+") then
		local sender,hostn,chan = receive:match(":(.+)!(.+) PRIVMSG #(.+) :.+")
		lmess[sender] = receive:match(":.+ PRIVMSG #.+ :(.+)")
	end
	if receive:match(":.+!.+ JOIN #.+") then
		checkin(receive:match(":(.+)!.+ JOIN #.+"),receive:match(":.+!.+ JOIN #(.+)"))
	end
	if receive:match(":.+!.+ PART #.+") or receive:match(":.+!.+ QUIT :.+") then
		print("[-]--------------------------")
		for k,v in pairs(lmess) do
			print("[*] "..k,v)
		end
		for k,v in pairs(lseen) do
			print("[*] "..k,v)
		end
		print("[-]--------------------------")
		local user = receive:match(":(.+)!.+ .+T")
		local lastmess = lmess[user]
		local dat = os.date()
		local did = false
		for i = 1,3000 do
			local dfd = string.match(tostring(lseen[i]),"(.+)////.+||||.+")
			if string.match(tostring(dfd),user) then
				print("[C] Matched "..tostring(dfd))
				print("[C] "..i.. " is "..tostring(lseen[i]).. " and LMess is "..tostring(lastmess))
				if not lastmess then
					print("[+] Created one in NOT LMess and ALEX with "..tostring(lastmess))
					lseen[i] = user.."////"..dat.."||||".."Nilninlnklfgdkhijoihreiuwhigger48397834"
					did = true
					break
				else
					print("[+] Created one in TRUE LMess and ALEX with "..tostring(lastmess))
					lseen[i] = user.."////"..dat.."||||"..tostring(lastmess)
					did = true
					break
				end
			end
		end
		if not did then
			for i = 1,3000 do
				if not lseen[i] then
					print("[C] "..i.. " is "..tostring(lseen[i]).. " and LMess is "..tostring(lastmess))
					if not lastmess then
						print("[+] Created one in NOT LMess and NOT ALEX with "..tostring(lastmess))
						lseen[i] = user.."////"..dat.."||||".."Nilninlnklfgdkhijoihreiuwhigger48397834"
						did = true
						break
					else
						print("[+] Created one in TRUE LMess and NOT ALEX with "..tostring(lastmess))
						lseen[i] = user.."////"..dat.."||||"..tostring(lastmess)
						did = true
						break
					end
				end
			end
		end
		seenwrite()
		seenread()
	end
end
