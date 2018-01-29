initialization
initialize
	ArithmeticSelectors := #(+ - * / %).
	BitwiseSelectors := #(& | ^ << >> bitAnd: bitOr: bitXor: bitShift: ).
	ComparisonSelectors := #(+ - * / %).
	self buildCoercionTables.
	