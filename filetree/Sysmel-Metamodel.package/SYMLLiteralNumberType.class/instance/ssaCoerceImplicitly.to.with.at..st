coercion
ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition
	targetType isIntegerType ifTrue: [ ^ SLVMConstant type: targetType ssaType value: value asInteger ].
	targetType isFloatType ifTrue: [ ^ SLVMConstant type: targetType ssaType value: value asFloat ].
	^ super ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition