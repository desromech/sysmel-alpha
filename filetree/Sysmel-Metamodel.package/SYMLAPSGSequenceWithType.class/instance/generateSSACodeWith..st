meta evaluation
generateSSACodeWith: builder
	| result |
	result := nil.
	elements do: [ :expr | result := expr generateSSACodeWith: builder ].
	result ifNil: [ self halt ].
	^ result