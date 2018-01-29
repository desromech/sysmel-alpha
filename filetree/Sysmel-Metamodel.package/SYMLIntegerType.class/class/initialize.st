initialization
initialize
	super initialize.

	SignedIntegerOperationMap := Dictionary newFromPairs: #(
		+ add
		- sub
		* mul
		/ div
		% rem
		
		& bitand
		bitAnd: bitand
		| bitor
		bitOr: bitor
		^ bitxor
		bitXor: bitxor
		
		<< shiftleft
		>> shiftrightarithmetic
		
		== ieq
		~= ine

		< ilt
		<= ile
		> igt
		>= ige
	).
	
	UnsignedIntegerOperationMap := Dictionary newFromPairs: #(
		+ add
		- sub
		* mul
		/ udiv
		% urem
		
		& bitand
		bitAnd: bitand
		| bitor
		bitOr: bitor
		^ bitxor
		bitXor: bitxor
		
		<< shiftleft
		>> shiftrightarithmetic
		
		== ieq
		~= ine

		< ult
		<= ule
		> ugt
		>= uge
	).