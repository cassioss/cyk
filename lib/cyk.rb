require "cyk/version"

### CYK (Cocke-Younger-Kasami) algorithm
# Parsing algorithm for context-free grammars (CFG) in the Chomsky Normal Form (CNF)

# It will be considered that the first state of a CFG is always the starting state, and :eps is equivalent to the empty string

module Cyk

	# Concatenates elements of two arrays

	def concatenate(array1, array2)
		array3 = Array.new
		if array1 == [] || array2 == [] || array1 == nil || array2 == nil
			array3 = []
		else
			array1.each do |element1|
				array2.each do |element2|
					array3 << element1 + element2
				end
			end
		end
		array3
	end
	
	# Returns the non-terminal states that generate a state in the form "a" or "AB",
	# using a loop to iterate over all the states

	def produces_loop(array1, array2, cfg)
		united = unite(array1, array2)
		prod2 = []
		united.each do |element|
			prod2 = prod2 + produces(element, cfg)
		end
		prod2.uniq
	end

	# A single iteration of the loop above
	
	def produces(state12, cfg)
		prod = []
		cfg.each do |key, values|
			values.each do |one_value|
				if one_value == state12
					prod << key
				end
			end
		end
		prod
	end
	
	### The CYK algorithm itself

	def cyk(cnf, a_string)
		n = a_string.length
		matrix = Hash.new
		matrix.default = []
		
		## First, it is necessary to find the first line of the algorithm
		## The first line brings the states that generate each one of the symbols of the string
		
		for i in 0..n-1
			matrix[[0,i]] = produces(a_string[i], cnf)
		end
		
		## After this line is created, the other lines can be brought by the same loop
		
		for i in 1..n-1
			for j in i..n-1
				for k in 0..i-1
					matrix[[i,j]] = matrix[[i,j]] + produces_loop(matrix[[k, j-i+k]], matrix[[i-1-k, j]], cnf)
				end
			end
			matrix[[i,j]] = matrix[[i,j]].uniq
		end
		matrix
	end
	
	# Prints a grammar, which is a hash
	
	def puts_grammar(cnf)
		cnf.each {|state, production| puts "#{state} => #{production}"}
		print "\n"
	end
	
	# Brings a friendly way to print the algorithm being used for a string
	
	def solve(cfg, a_string)
		mat = cyk(cfg, a_string)
		n = a_string.length
		puts "CYK Algorithm - Grammar in the Chomsky Normal Form:\n\n"
		puts_grammar(cfg)
		puts "CYK Algorithm - String \"" + a_string + "\":"
		print "\n"
		for i in 0..n-1
			a = i+1
			print "Line " + a.to_s + ":"
			for j in i..n-1
				print " " + mat[[i,j]].uniq.inspect
			end
			print "\n"
		end
		if mat[[n-1,n-1]] != []
			puts "\nThe string \"" + a_string + "\" belongs to the grammar.\n\n"
		else
			puts "\nThe string \"" + a_string + "\" does not belong to the grammar.\n\n"
		end
	end

end
