require 'string'
require 'io'

----------------- string helper functions-----------------------

-- split the string with the given delimiter and return a table
function split(str,delimiter)
	t = {}
	substr = ""
	for i=1, #str do
		local c = str:sub(i,i)
		if c==delimiter then
			table.insert(t,substr)
			substr = ""
		else
			substr = substr .. c	
		end
	end
	table.insert(t,substr)
	return t
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

------------------- table helper funcitons------------------

-- count the number of element in the table
function tableElementCount(t)
	count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

-- extract the subtable from first to last(inclusive) from t
-- expect keys to be integer value
function tableSubRange(t,first,last)
	if not isArray(t) then error("Table must be integer value indexed") end
	subtable = {}
	for i=first,last do
		subtable[#subtable +1] = t[i]
	end
	return subtable
end

-- Check whether table is array or not
function isArray(t)
	local i = 0
	for _ in pairs(t) do
		i = i + 1
		if t[i] == nil then return false end
	end
	return true
end

-- method to print table key,value pair
function printTable(t)
	for key,value in pairs(t) do
		print(key .. " " .. value)
	end
end

-- write table (key,value) pair to file
function writeTableToFile(file,t)
	local f = assert(io.open(file,"w"))
	for key,value in pairs(t) do
		f:write(key .. " " .. value .. "\n")
	end
end

-------------------------- file functions------

function  file_exists(file)
	local f = io.open(file,"r")
	if f~=nil then io.close(f) return true else return false end
end

----------------------------------------Serialization and Desirialization------------------------

function serialize(file,obj)
	torch.save(file,obj)
end

function deserialize(file)
	return torch.load(file)
end