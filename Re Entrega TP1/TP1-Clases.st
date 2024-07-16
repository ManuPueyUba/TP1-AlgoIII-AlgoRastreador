Object subclass: #Criterio
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Criterio class
	instanceVariableNames: ''!

!Criterio class methodsFor: 'as yet unclassified' stamp: '5/9/2024 20:45'!
deTipo: unCriterio
    | criterios criterio |
	criterios := Dictionary new.
	criterios at: 'Fuerte' put: CriterioFuerte new.
	criterios at: 'Debil' put: CriterioDebil new.
	
	criterio := criterios at: unCriterio ifAbsent: [ CriterioNoValidoException signal: 'Tipo de criterio no válido' ].
    ^criterio.
! !


Criterio subclass: #CriterioDebil
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

!CriterioDebil methodsFor: 'as yet unclassified' stamp: '5/9/2024 22:40'!
buscarPeleadorEnListaDePeleadores: historial
    | peleadorMinimo |

    historial ifEmpty: [
        PeleadorNoRegistradoException signal: 'No hay Rastreos, rastrea antes de Buscar un peleador'.
    ].
    peleadorMinimo := historial detectMin: [ :peleador |
        peleador obtenerNivelDePelea ].

    ^ peleadorMinimo obtenerNombre.
! !


Object subclass: #Modelo
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

!Modelo methodsFor: 'as yet unclassified' stamp: '5/8/2024 19:42'!
medirKi: unKi
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Modelo class
	instanceVariableNames: ''!

!Modelo class methodsFor: 'as yet unclassified' stamp: '5/9/2024 20:44'!
deTipo: unModelo
    | modelos modelo |
	modelos := Dictionary new.
	modelos at: 'Viejo' put: ModeloViejo new.
	modelos at: 'Nuevo' put: ModeloNuevo new.
	
	modelo := modelos at: unModelo ifAbsent: [ ModeloNoValidoException signal: 'Tipo de modelo no válido' ].
    ^modelo.
! !


Error subclass: #PeleadorNoRegistradoException
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

Object subclass: #AlgoRastreadorZ
	instanceVariableNames: 'peleadores criterio'
	classVariableNames: ''
	package: 'TP1-Clases'!
!AlgoRastreadorZ commentStamp: 'Anonymous 5/9/2024 22:21' prior: 0!
Class AlgoRastreadorZ

Methods: 
conCriterioMas: unCriterio
nivelDePeleaDe: unNombre
obtenerPeleadorSegunCriterio
registrarRastreoConModelo: unModelo delPeleadorConNombre: unNombre KiBase: unKi yTransformacion: unaTransformacion

Atributes:
criterio: Criterio
peleadores: OrderedCollection<Peleador>

!


!AlgoRastreadorZ methodsFor: 'initialization' stamp: '5/7/2024 23:39'!
initialize 
	peleadores := OrderedCollection new.! !

!AlgoRastreadorZ methodsFor: 'initialization' stamp: '4/18/2024 21:51'!
conCriterioMas: unCriterio 
	criterio := unCriterio.! !


!AlgoRastreadorZ methodsFor: 'user-interface' stamp: '5/9/2024 22:23'!
registrarRastreoConModelo: unModelo delPeleadorConNombre: unNombre KiBase: unKi yTransformacion: unaTransformacion

	| transformacion modelo peleador |
	"Crea el modelo"
	modelo := Modelo deTipo: unModelo.
	transformacion := Transformacion deTipo: unaTransformacion.
	
	peleador := Peleador conNombre: unNombre conModelo: modelo transformacion: transformacion yKiBase: unKi.

	peleadores add: (peleador).
	! !

!AlgoRastreadorZ methodsFor: 'user-interface' stamp: '5/9/2024 23:14'!
nivelDePeleaDe: unNombre
 	| peleadorEncontrado |   
	 	
	 peleadorEncontrado := [(peleadores detect: [ :peleador | peleador es: unNombre ])] on: NotFound do: [PeleadorNoRegistradoException signal: 'El Peleador no se encuentra registrado'].
	
	^ peleadorEncontrado obtenerNivelDePelea.! !

!AlgoRastreadorZ methodsFor: 'user-interface' stamp: '5/9/2024 22:23'!
obtenerPeleadorSegunCriterio
	^criterio buscarPeleadorEnListaDePeleadores: peleadores. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

AlgoRastreadorZ class
	instanceVariableNames: ''!
!AlgoRastreadorZ class commentStamp: 'Anonymous 5/9/2024 22:21' prior: 0!
Class AlgoRastreadorZ

Methods: 
conCriterioMas: unCriterio
nivelDePeleaDe: unNombre
obtenerPeleadorSegunCriterio
registrarRastreoConModelo: unModelo delPeleadorConNombre: unNombre KiBase: unKi yTransformacion: unaTransformacion

Atributes:
criterio: Criterio
peleadores: OrderedCollection<Peleador>

!


!AlgoRastreadorZ class methodsFor: 'initialization' stamp: '5/9/2024 22:16'!
conCriterioMas: unCriterio
	| rastreador criterio|
	rastreador := self new.
	
	criterio := Criterio deTipo: unCriterio.
	rastreador conCriterioMas: criterio.
	^ rastreador! !


Error subclass: #CriterioNoValidoException
	instanceVariableNames: 'historial criterio'
	classVariableNames: ''
	package: 'TP1-Clases'!

Modelo subclass: #ModeloViejo
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

!ModeloViejo methodsFor: 'as yet unclassified' stamp: '5/7/2024 23:21'!
medirKi: unKi
	| ki |
	ki := unKi min: 9000.
	^ki
	! !


Object subclass: #Peleador
	instanceVariableNames: 'modelo transformacion kiBase nombre'
	classVariableNames: ''
	package: 'TP1-Clases'!

!Peleador methodsFor: 'as yet unclassified' stamp: '5/9/2024 20:59'!
conNombre: unNombre conModelo: unModelo transformacion: unaTransformacion yKiBase: unKi
	nombre := unNombre.
	modelo := unModelo.
	transformacion := unaTransformacion.
	self comprobarKi: unKi.
	kiBase := unKi.
	! !

!Peleador methodsFor: 'as yet unclassified' stamp: '5/7/2024 23:07'!
es: unNombre 
	^ (nombre = unNombre).! !

!Peleador methodsFor: 'as yet unclassified' stamp: '5/7/2024 23:22'!
obtenerNombre
	^nombre.! !

!Peleador methodsFor: 'as yet unclassified' stamp: '5/9/2024 20:50'!
obtenerNivelDePelea
	| kiTransformado kiTotal |
	kiTransformado := transformacion transformarKi: kiBase.
	kiTotal := modelo medirKi: kiTransformado.
	^kiTotal! !

!Peleador methodsFor: 'as yet unclassified' stamp: '5/9/2024 20:57'!
comprobarKi: unKi
	(unKi >0) ifFalse: [ KiNoValidoException signal: 'El ki ingresado no es Valido tiene que ser mayor a 0' ].
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Peleador class
	instanceVariableNames: ''!

!Peleador class methodsFor: 'as yet unclassified' stamp: '5/9/2024 21:00'!
conNombre: unNombre conModelo: unModelo transformacion: unaTransformacion yKiBase: unKi
	| peleador |
	peleador := self new.
	peleador conNombre: unNombre conModelo: unModelo transformacion: unaTransformacion yKiBase: unKi.
	^peleador

	! !


Object subclass: #Transformacion
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!
!Transformacion commentStamp: 'Anonymous 5/7/2024 14:02' prior: 0!
Class: Transformacion

inst.Side 
#Comprueba que el ki sea > a 0
comprobarKi: unKi
	(unKi > 0) ifFalse: [ KiNoValidoException signal: 'El Ki tiene que ser mayor a 0'].
	
Class Side

#Crea la transformacion deseada
crear: unaTransformacion 
	| transformacion |
	unaTransformacion = 'Base' ifTrue: [ transformacion := Base new ].

	unaTransformacion = 'Kaio-Ken' ifTrue: [ 
		transformacion := KaioKen new ].

	unaTransformacion = 'Mono Gigante' ifTrue: [ 
		transformacion := MonoGigante new ].
	"transformacion ifNil: [TransformacionNoValidaException signal: 'La transformacion ""', unaTransformacion , '"" no es valida.']."
	^transformacion!


!Transformacion methodsFor: 'as yet unclassified' stamp: '5/8/2024 10:52'!
transformarKi: ki
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Transformacion class
	instanceVariableNames: ''!
!Transformacion class commentStamp: 'Anonymous 5/7/2024 14:02' prior: 0!
Class: Transformacion

inst.Side 
#Comprueba que el ki sea > a 0
comprobarKi: unKi
	(unKi > 0) ifFalse: [ KiNoValidoException signal: 'El Ki tiene que ser mayor a 0'].
	
Class Side

#Crea la transformacion deseada
crear: unaTransformacion 
	| transformacion |
	unaTransformacion = 'Base' ifTrue: [ transformacion := Base new ].

	unaTransformacion = 'Kaio-Ken' ifTrue: [ 
		transformacion := KaioKen new ].

	unaTransformacion = 'Mono Gigante' ifTrue: [ 
		transformacion := MonoGigante new ].
	"transformacion ifNil: [TransformacionNoValidaException signal: 'La transformacion ""', unaTransformacion , '"" no es valida.']."
	^transformacion!


!Transformacion class methodsFor: 'as yet unclassified' stamp: '5/9/2024 20:45'!
deTipo: unaTransformacion
    | transformacion transformaciones |
	transformaciones := Dictionary new.
	transformaciones at: 'Base' put: Base new.
	transformaciones at: 'Kaio-Ken' put: KaioKen new.
	transformaciones at: 'Mono Gigante' put: MonoGigante new.
	
	transformacion := transformaciones at: unaTransformacion ifAbsent: [ TransformacionNoValidaException signal: 'Tipo de transformacion no válida' ].
    ^transformacion.

! !


Transformacion subclass: #KaioKen
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!
!KaioKen commentStamp: 'Anonymous 5/7/2024 14:00' prior: 0!
Class KaioKen

This Class only has one method called
transformarKi: unKi
	comprobarKi: unKi
	^ (2 * unKi)
receives an int and returns the same 2 * int!


!KaioKen methodsFor: 'as yet unclassified' stamp: '5/9/2024 21:01'!
transformarKi: unKi
	^ 2*unKi! !


Transformacion subclass: #MonoGigante
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!
!MonoGigante commentStamp: 'Anonymous 5/7/2024 14:00' prior: 0!
Class MonoGigante
Method/s

transformarKi: unKi
	self comprobarKi: unKi.
	^(unKi*10) asLargerPowerOfTwo

!


!MonoGigante methodsFor: 'as yet unclassified' stamp: '5/9/2024 21:01'!
transformarKi: unKi
	^(unKi*10) asLargerPowerOfTwo! !


Error subclass: #ModeloNoValidoException
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

Transformacion subclass: #Base
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!
!Base commentStamp: 'Anonymous 5/7/2024 13:57' prior: 0!
Class Base

This Class only has one method called
transformarKi: unKi
	^ unKi
receives an int and returns the same int!


!Base methodsFor: 'as yet unclassified' stamp: '5/9/2024 21:01'!
transformarKi: unKi 
	^unKi ! !


Criterio subclass: #CriterioFuerte
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

!CriterioFuerte methodsFor: 'as yet unclassified' stamp: '5/9/2024 22:41'!
buscarPeleadorEnListaDePeleadores: historial
    | peleadorMaximo |

    historial ifEmpty: [
        PeleadorNoRegistradoException signal: 'No hay Rastreos, rastrea antes de Buscar un peleador'.
    ].
    peleadorMaximo := historial detectMax: [ :peleador |
        peleador obtenerNivelDePelea ].

    ^ peleadorMaximo obtenerNombre.
! !


Error subclass: #KiNoValidoException
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

Modelo subclass: #ModeloNuevo
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!

!ModeloNuevo methodsFor: 'as yet unclassified' stamp: '5/7/2024 23:21'!
medirKi: unKi 
	^unKi.! !


Error subclass: #TransformacionNoValidaException
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'TP1-Clases'!