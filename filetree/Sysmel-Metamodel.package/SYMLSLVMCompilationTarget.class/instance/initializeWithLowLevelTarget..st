initialization
initializeWithLowLevelTarget: aLowLevelCompilationTarget
	lowLevelTarget := aLowLevelCompilationTarget.

	metaTypes := IdentityDictionary new.
	constTypes := IdentityDictionary new.
	volatileTypes := IdentityDictionary new.
	pointerTypes := IdentityDictionary new.
	referenceTypes := IdentityDictionary new.
	functionTypes := WeakValueDictionary new.
	tupleTypes := WeakValueDictionary new.
	
	builtInTypes := {
		voidType := SYMLVoidType new target: self.
		
		booleanType := SYMLBooleanType new target: self; name: #Boolean; size: 1; alignment: 1; ssaType: lowLevelTarget bool.
		uint8Type := SYMLIntegerType new target: self; name: #UInt8; signed: false; size: 1; alignment: 1; ssaType: lowLevelTarget uint8.
		uint16Type := SYMLIntegerType new target: self; name: #UInt16; signed: false; size: 2; alignment: 2; ssaType: lowLevelTarget uint16.
		uint32Type := SYMLIntegerType new target: self; name: #UInt32; signed: false; size: 4; alignment: 4; ssaType: lowLevelTarget uint32.
		uint64Type := SYMLIntegerType new target: self; name: #UInt64; signed: false; size: 8; alignment: 8; ssaType: lowLevelTarget uint64.

		int8Type := SYMLIntegerType new target: self; name: #Int8; signed: true; size: 1; alignment: 1; ssaType: lowLevelTarget int8.
		int16Type := SYMLIntegerType new target: self; name: #Int16; signed: true; size: 2; alignment: 2; ssaType: lowLevelTarget int16.
		int32Type := SYMLIntegerType new target: self; name: #Int32; signed: true; size: 4; alignment: 4; ssaType: lowLevelTarget int32.
		int64Type := SYMLIntegerType new target: self; name: #Int64; signed: true; size: 8; alignment: 8; ssaType: lowLevelTarget int64.

		float32Type := SYMLIntegerType new target: self; name: #Float32; signed: true; size: 4; alignment: 4; ssaType: lowLevelTarget float32.
		float64Type := SYMLIntegerType new target: self; name: #Float64; signed: true; size: 8; alignment: (lowLevelTarget double alignment); ssaType: lowLevelTarget float64.

		characterType := SYMLAliasType for: uint8Type name: #Char.
	
		astNodeType := SYMLASTNodeType new target: self.
		apsgNodeType := SYMLAPSGNodeType new target: self.
		compilerObjectType := SYMLCompilerObjectType new target: self.
		
		literalIntegerType := SYMLLiteralIntegerType new target: self.
		literalFloatType := SYMLLiteralFloatType new target: self.
		literalBooleanType := SYMLLiteralBooleanType new target: self.
		literalCharacterType := SYMLLiteralCharacterType new target: self.
		literalStringType := SYMLLiteralStringType new target: self.
		literalSymbolType := SYMLLiteralSymbolType new target: self.
		literalArrayType := SYMLLiteralArrayType new target: self.
	}	
