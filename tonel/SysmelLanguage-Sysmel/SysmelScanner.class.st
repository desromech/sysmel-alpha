Class {
	#name : #SysmelScanner,
	#superclass : #SmaCCScanner,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #'generated-initialization' }
SysmelScanner class >> initializeKeywordMap [
	keywordMap := Dictionary new.
	#(#(55 '&&' 13) #(55 '//' 11) #(55 '<<' 1) #(55 '<=' 8) #(55 '==' 18) #(55 '>=' 9) #(55 '>>' 3) #(55 '||' 16) #(55 '~=' 17) #(55 '~~' 19))
		do: [ :each | 
			(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
				at: (each at: 2)
				put: each last ].
	^ keywordMap
]

{ #category : #generated }
SysmelScanner class >> states [
	^ #(#default)
]

{ #category : #generated }
SysmelScanner >> emptySymbolTokenId [
	^ 132
]

{ #category : #generated }
SysmelScanner >> errorTokenId [
	^ 133
]

{ #category : #generated }
SysmelScanner >> scan1 [
	[ self step.
	currentCharacter == $"
		ifTrue: [ ^ self recordAndReportMatch: #(48) ].
	currentCharacter == $\
		ifTrue: [ self step.
			^ self scan1 ].
	true ] whileTrue
]

{ #category : #generated }
SysmelScanner >> scan2 [
	[ self step.
	currentCharacter == $"
		ifTrue: [ ^ self recordAndReportMatch: #(53) ].
	currentCharacter == $\
		ifTrue: [ self step.
			^ self scan2 ].
	true ] whileTrue
]

{ #category : #generated }
SysmelScanner >> scan3 [
	[ self recordMatch: #(52).
	self step.
	currentCharacter == $*
		ifTrue: [ [ self recordMatch: #(52).
			self step.
			currentCharacter == $#
				ifTrue: [ ^ self recordAndReportMatch: #(43) ].
			currentCharacter == $* ] whileTrue.
			(currentCharacter isSpecial or: [ currentCharacter == $^ ])
				ifTrue: [ ^ self scan3 ].
			^ self scan4 ].
	currentCharacter isSpecial or: [ currentCharacter == $^ ] ] whileTrue.
	^ self scan4
]

{ #category : #generated }
SysmelScanner >> scan4 [
	[ self step.
	currentCharacter == $*
		ifTrue: [ [ self step.
			currentCharacter == $#
				ifTrue: [ ^ self recordAndReportMatch: #(43) ].
			currentCharacter == $* ] whileTrue.
			^ self scan4 ].
	true ] whileTrue
]

{ #category : #generated }
SysmelScanner >> scan5 [
	self recordMatch: #(50).
	self step.
	((currentCharacter between: $A and: $Z)
		or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ])
		ifTrue: [ [ self step.
			currentCharacter == $:
				ifTrue: [ ^ self scan5 ].
			(currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scan6 [
	[ self step.
	currentCharacter == $'
		ifTrue: [ ^ self recordAndReportMatch: #(49) ].
	currentCharacter == $\
		ifTrue: [ self step.
			^ self scan6 ].
	true ] whileTrue
]

{ #category : #generated }
SysmelScanner >> scan7 [
	[ self recordMatch: #(45).
	self step.
	currentCharacter == $.
		ifTrue: [ self step.
			(currentCharacter between: $0 and: $9)
				ifTrue: [ [ self recordMatch: #(44).
					self step.
					currentCharacter between: $0 and: $9 ] whileTrue.
					('Ee' includes: currentCharacter)
						ifTrue: [ self step.
							(currentCharacter between: $0 and: $9)
								ifTrue: [ [ self recordMatch: #(44).
									self step.
									currentCharacter between: $0 and: $9 ] whileTrue.
									^ self reportLastMatch ].
							('+-' includes: currentCharacter)
								ifTrue: [ self step.
									(currentCharacter between: $0 and: $9)
										ifTrue: [ [ self recordMatch: #(44).
											self step.
											currentCharacter between: $0 and: $9 ] whileTrue ] ] ] ].
			^ self reportLastMatch ].
	currentCharacter == $r
		ifTrue: [ self step.
			((currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter between: $a and: $z ] ])
				ifTrue: [ [ self recordMatch: #(45).
					self step.
					(currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter between: $a and: $z ] ] ] whileTrue ].
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scan8 [
	self recordMatch: #(46).
	self step.
	((currentCharacter between: $A and: $Z)
		or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ])
		ifTrue: [ [ self step.
			currentCharacter == $:
				ifTrue: [ ^ self scan8 ].
			(currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForToken [
	self step.
	currentCharacter == $!
		ifTrue:
			[ ^ self scanForTokenX17 ].
	currentCharacter == $"
		ifTrue: [ ^ self scan1 ].
	^ self scanForTokenX22
]

{ #category : #generated }
SysmelScanner >> scanForTokenX1 [
	self step.
	currentCharacter == $"
		ifTrue: [ ^ self scan2 ].
	currentCharacter == $#
		ifTrue:
			[ ^ self scanForTokenX1X2 ].
	currentCharacter == $(
		ifTrue: [ ^ self recordAndReportMatch: #(32) ].
	currentCharacter == $*
		ifTrue: [ ^ self scan3 ].
	currentCharacter == ${
		ifTrue: [ ^ self recordAndReportMatch: #(27) ].
	((currentCharacter between: $A and: $Z)
		or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ])
		ifTrue:
			[ ^ self scanForTokenX1X1 ].
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(52).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX10 [
	self recordMatch: #(21 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX11 [
	self recordMatch: #(5 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX12 [
	self recordMatch: #(6 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX13 [
	self recordMatch: #(34 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX14 [
	self recordMatch: #(7 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX15 [
	self recordMatch: #(15 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX16 [
	self recordMatch: #(20 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX17 [
	self recordMatch: #(36 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX18 [
	[ self recordMatch: #(42).
	self step.
	currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX19 [
	[ self recordMatch: #(55).
	self step.
	currentCharacter isSpecial or: [ currentCharacter == $^ ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX1X1 [
	[ self recordMatch: #(51).
	self step.
	currentCharacter == $:
		ifTrue: [ ^ self scan5 ].
	(currentCharacter between: $0 and: $9)
		or: [ (currentCharacter between: $A and: $Z)
				or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX1X2 [
	[ self recordMatch: #(43).
	self step.
	currentCharacter <= Character tab
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ currentCharacter >= (Character value: 14) ] ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX2 [
	self recordMatch: #(28).
	self step.
	currentCharacter == $:
		ifTrue: [ self recordMatch: #(31).
			self step.
			(currentCharacter isSpecial or: [ currentCharacter == $^ ])
				ifTrue: [ [ self recordMatch: #(54).
					self step.
					currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
						whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(33) ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX20 [
	currentCharacter == $~
		ifTrue:
			[ ^ self scanForTokenX6 ].
	(currentCharacter between: $0 and: $9)
		ifTrue: [ ^ self scan7 ].
	currentCharacter isSpecial
		ifTrue:
			[ ^ self scanForTokenX19 ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue:
			[ ^ self scanForTokenX18 ].
	currentCharacter isSafeForHTTP
		ifTrue: [ [ self recordMatch: #(47).
			self step.
			currentCharacter == $:
				ifTrue: [ ^ self scan8 ].
			(currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX21 [
	currentCharacter == $:
		ifTrue:
			[ ^ self scanForTokenX2 ].
	currentCharacter == $;
		ifTrue: [ ^ self recordAndReportMatch: #(35) ].
	currentCharacter == $<
		ifTrue:
			[ ^ self scanForTokenX11 ].
	currentCharacter == $=
		ifTrue:
			[ ^ self scanForTokenX10 ].
	currentCharacter == $>
		ifTrue:
			[ ^ self scanForTokenX9 ].
	currentCharacter == $[
		ifTrue: [ ^ self recordAndReportMatch: #(40) ].
	currentCharacter == $]
		ifTrue: [ ^ self recordAndReportMatch: #(29) ].
	currentCharacter == $^
		ifTrue:
			[ ^ self scanForTokenX8 ].
	currentCharacter == $`
		ifTrue:
			[ ^ self scanForTokenX5 ].
	currentCharacter == ${
		ifTrue: [ ^ self recordAndReportMatch: #(24) ].
	currentCharacter == $|
		ifTrue:
			[ ^ self scanForTokenX7 ].
	currentCharacter == $}
		ifTrue: [ ^ self recordAndReportMatch: #(25) ].
	^ self scanForTokenX20
]

{ #category : #generated }
SysmelScanner >> scanForTokenX22 [
	currentCharacter == $#
		ifTrue:
			[ ^ self scanForTokenX1 ].
	currentCharacter == $%
		ifTrue:
			[ ^ self scanForTokenX16 ].
	currentCharacter == $&
		ifTrue:
			[ ^ self scanForTokenX15 ].
	currentCharacter == $'
		ifTrue: [ ^ self scan6 ].
	currentCharacter == $(
		ifTrue: [ ^ self recordAndReportMatch: #(39) ].
	currentCharacter == $)
		ifTrue: [ ^ self recordAndReportMatch: #(38) ].
	currentCharacter == $*
		ifTrue:
			[ ^ self scanForTokenX14 ].
	currentCharacter == $+
		ifTrue:
			[ ^ self scanForTokenX4 ].
	currentCharacter == $,
		ifTrue:
			[ ^ self scanForTokenX13 ].
	currentCharacter == $-
		ifTrue:
			[ ^ self scanForTokenX3 ].
	currentCharacter == $.
		ifTrue: [ ^ self recordAndReportMatch: #(37) ].
	currentCharacter == $/
		ifTrue:
			[ ^ self scanForTokenX12 ].
	^ self scanForTokenX21
]

{ #category : #generated }
SysmelScanner >> scanForTokenX3 [
	self recordMatch: #(10 55).
	self step.
	(currentCharacter between: $0 and: $9)
		ifTrue: [ ^ self scan7 ].
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX4 [
	self recordMatch: #(4 55).
	self step.
	(currentCharacter between: $0 and: $9)
		ifTrue: [ ^ self scan7 ].
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX5 [
	self step.
	currentCharacter == $'
		ifTrue: [ ^ self recordAndReportMatch: #(26) ].
	currentCharacter == $,
		ifTrue: [ ^ self recordAndReportMatch: #(30) ].
	currentCharacter == $@
		ifTrue: [ ^ self recordAndReportMatch: #(22) ].
	currentCharacter == $`
		ifTrue: [ ^ self recordAndReportMatch: #(23) ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX6 [
	self recordMatch: #(41 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX7 [
	self recordMatch: #(12 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX8 [
	self recordMatch: #(14 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> scanForTokenX9 [
	self recordMatch: #(2 55).
	self step.
	(currentCharacter isSpecial or: [ currentCharacter == $^ ])
		ifTrue: [ [ self recordMatch: #(55).
			self step.
			currentCharacter isSpecial or: [ currentCharacter == $^ ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
SysmelScanner >> tokenActions [
	^ #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #whitespace #comment)
]
