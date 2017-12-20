initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	SpecialOperators := Set newFrom: #(
		!
		~

		*
		/
		%
		+
		-
		<<
		>>
		<=
		>=
		<
		>
		=
		~=
		==
		~~
		&
		^
		|
		&&
		#,
	)