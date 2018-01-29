as yet unclassified
coerce: left with: right
	dictionary at: { left class . right class } ifPresent: [ :rule |
		^ rule value: left value: left value: right
	].
	^ nil
