coercion
coerceImplicitlyValue: aValue at: aSourcePosition
	^ aValue type value: aValue coercedImplicitlyInto: self at: aSourcePosition