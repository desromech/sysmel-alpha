self importPackage: #zlib.
self platform name selectCase: {
    #linux -> [
        self importLibrary: 'png' fromDebianPackage: 'libpng-dev'.
    ].
    #osx -> [

    ].
    #windows -> [

    ].
    [true] -> []
}.
