initialization
initializeWithLowLevelTarget: aLowLevelCompilationTarget
	lowLevelTarget := aLowLevelCompilationTarget.

	metaTypes := IdentityDictionary new.
	constTypes := IdentityDictionary new.
	volatileTypes := IdentityDictionary new.
	pointerTypes := IdentityDictionary new.
	referenceTypes := IdentityDictionary new.
	functionTypes := WeakValueDictionary new.
	
	builtInTypes := {
		voidType := SYMLVoidType new target: self.
		
		booleanType := SYMLBooleanType new target: self; name: #Boolean; size: 1; alignment: 1.
		uint8Type := SYMLIntegerType new target: self; name: #UInt8; signed: false; size: 1; alignment: 1.
		uint16Type := SYMLIntegerType new target: self; name: #UInt16; signed: false; size: 2; alignment: 2.
		uint32Type := SYMLIntegerType new target: self; name: #UInt32; signed: false; size: 4; alignment: 4.
		uint64Type := SYMLIntegerType new target: self; name: #UInt64; signed: false; size: 8; alignment: 8.

		int8Type := SYMLIntegerType new target: self; name: #Int8; signed: true; size: 1; alignment: 1.
		int16Type := SYMLIntegerType new target: self; name: #Int16; signed: true; size: 2; alignment: 2.
		int32Type := SYMLIntegerType new target: self; name: #Int32; signed: true; size: 4; alignment: 4.
		int64Type := SYMLIntegerType new target: self; name: #Int64; signed: true; size: 8; alignment: 8.

		float32Type := SYMLIntegerType new target: self; name: #Float32; signed: true; size: 4; alignment: 4.
		float64Type := SYMLIntegerType new target: self; name: #Float64; signed: true; size: 8; alignment: (lowLevelTarget double alignment).

		characterType := SYMLAliasType for: uint8Type name: #Char.
	
		astNodeType := SYMLASTNodeType new target: self.
		apsgNodeType := SYMLAPSGNodeType new target: self.
		compilerObjectType := SYMLCompilerObjectType new target: self.
		
		literalIntegerType := SYMLLiteralIntegerType new target: self.
		literalFloatType := SYMLLiteralFloatType new target: self.
		literalCharacterType := SYMLLiteralCharacterType new target: self.
		literalStringType := SYMLLiteralStringType new target: self.
		literalSymbolType := SYMLLiteralSymbolType new target: self.
	}	
