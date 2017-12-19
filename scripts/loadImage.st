Metacello new
  baseline: 'Sysmel';
  repository: 'filetree://filetree';
  load.

"Save the image"
(Smalltalk saveAs: 'sysmel')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
