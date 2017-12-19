accessing
start
	^ super start ==> [ :tokens |
		SYMLASTFile new
			headerComments: tokens first;
			expressions: tokens second;
			footerComments: tokens third;
			yourself
	]