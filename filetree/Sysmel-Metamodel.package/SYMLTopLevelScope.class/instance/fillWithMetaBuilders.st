accessing
fillWithMetaBuilders
	| builder |
	SYMLDefaultMetaBuilder allSubclassesDo: [ :sc |
		builder := sc new compilationTarget: module compilationTarget.
		symbols at: builder name put: builder
	]