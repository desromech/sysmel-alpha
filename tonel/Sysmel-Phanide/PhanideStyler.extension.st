Extension { #name : #PhanideStyler }

{ #category : #'*Sysmel-Phanide' }
PhanideStyler class >> sysmel [
	<styler>
	^ self styler: 'Sysmel' extensions: #(sysmel) commandHighlighter: SYMLSyntaxHighlighter
]
