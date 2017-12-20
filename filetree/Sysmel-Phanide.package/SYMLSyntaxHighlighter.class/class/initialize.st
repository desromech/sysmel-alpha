initialization
initialize
	super initialize.
	
	Keywords := Set newFrom: #(
		#true #false #nil
		thisContext self super
		
		let namespace struct function template method field
	).