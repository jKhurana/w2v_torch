require 'io'

dofile("utils.lua") --  load util file for various funcitons

-- global constants
glove_w2v_file_path = "glove.6B.300d.txt"
serialized_file_name = "w2v_serialized.t7"
BUFSIZE = 2^13 -- 8K

-- data structures
w2v_input_table = {}
input_vocab_table = {}

-- Download the Glove trained model if not locally available
function downloadData()
	if not file_exists(glove_w2v_file_path) then
		print("Downloading glove trained model.....")
		-- download using wget
	end
end

-- Generate w2v of input data
function generatew2v()
	print("Generating w2v model........")
	for lines, rest in io.lines(glove_w2v_file_path,BUFSIZE,"*l") do
		if rest then lines = lines .. rest end
		w2v_list = split(lines,"\n")
		for key,value in pairs(w2v_list) do
			t = split(value," ")
			if input_vocab_table[t[1]] ~= nil then 
				w2v_input_table[t[1]] = tableSubRange(t,2,tableElementCount(t))
			end
		end
	end
end

-- function to read input file
function readInputFile(file)
	print("Reading input file.......")
	local f = assert(io.open(file,"r"))
	for line in io.lines(file) do
		t = split(trim(line)," ")
		for key,value in pairs(t) do
			if input_vocab_table[value]==nil then 
				input_vocab_table[value] = 1
			else
				input_vocab_table[value] = input_vocab_table[value] + 1
			end
		end
	end
end

-- main function
function w2v_using_glove300(file)
	
	readInputFile(file)
	if tableElementCount(input_vocab_table)==0 then error("Error in Reading input file....") end
	
	-- write vocab file
	print("Writing vocab file......")
	writeTableToFile("vocab.txt",input_vocab_table)

	downloadData()
	
	generatew2v()
	if tableElementCount(w2v_input_table) == 0 then error("Error while generating word to vec") end

	-- serialize the w2v into file
	print("Writing serialized file.....")
	serialize(serialized_file_name,w2v_input_table)
end



