Extension { #name : #PhanideStyler }

{ #category : #'*SysmelLanguage-SysmelPhanide' }
PhanideStyler class >> sysmel [
	<styler>
	^ self styler: 'Sysmel' extensions: #(sysmel) commandHighlighter: SysmelSyntaxHighlighter
]
