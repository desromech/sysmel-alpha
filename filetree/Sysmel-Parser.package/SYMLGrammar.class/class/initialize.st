initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	Keywords := Set newFrom: #(
		#'nil' #'true' #'false'
		"self super thisContext"
	).