tests
testDefineFunction
	| function |
	function := module evaluateSource: 'function main () -> Void := {}'.
	
	self assert: function type isReferenceType.
	self assert: function type referenced isFunctionType.
	self assert: function value definition isSYMLASTNode.