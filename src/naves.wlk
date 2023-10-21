class Nave {
	var velocidad
	var direccion 
	var combustible
	
	method acelerar(cuanto) {velocidad= 100000.min(velocidad + cuanto)}
	method desacelerar(cuanto) {velocidad= 0.max(velocidad - cuanto)}
	method irHaciaElSol() {direccion= 10}
	method escaparDelSol() {direccion= -10}
	method ponerseParaleloAlSol() {direccion= 0}
	method acercarseUnPocoAlSol() {direccion= 10.min(direccion++)}
	method alejarseUnPocoDelSol() {direccion= -10.max(direccion--)}
	method prepararViaje() {self.cargarCombustible(30000) self.acelerar(5000)}
	
	method cargarCombustible(litros) {combustible += litros}
	method descargarCombustible(litros) {combustible= 0.max(combustible- litros)}
	method estaTranquila()= combustible >= 4000 && velocidad <= 12000 
	method estaDeRelajo()= self.estaTranquila() && self.tienePocaActividad()
	method tienePocaActividad()
}

class NaveBaliza inherits Nave {
	var color
	var contadorDeCambios= 0
	
	method cambiarColorDeBaliza(colorNuevo) {color= colorNuevo contadorDeCambios++}
	override method prepararViaje() {super() self.cambiarColorDeBaliza("verde") self.ponerseParaleloAlSol()}
	override method estaTranquila()= super() && color != "rojo"
	method escapar() {self.irHaciaElSol()}
	method avisar() {self.cambiarColorDeBaliza("rojo")}
	method recibirAmenaza() {self.escapar() self.avisar()}
	override method tienePocaActividad()= contadorDeCambios == 0 
}

class NaveDePasajeros inherits Nave {
	const cantidadDePasajeros
	var racionesDeComida
	var bebidas
	var racionesDeComidaServidas= 0
	
	override method prepararViaje() {super() self.cargarComida(4 * cantidadDePasajeros) self.cargarBebidas(6 * cantidadDePasajeros) self.irHaciaElSol()}
	method escapar() {velocidad= velocidad * 2}
	method avisar() { self.servirRaciones() }
	method recibirAmenaza() {self.escapar() self.avisar()}
	method cargarComida(racion) {racionesDeComida += racion}
	method cargarBebidas(racion) {bebidas += racion}
	override method tienePocaActividad()= racionesDeComidaServidas >= 50
	method servirRaciones() {racionesDeComida -= cantidadDePasajeros racionesDeComidaServidas += cantidadDePasajeros bebidas -= cantidadDePasajeros * 2}
}

class NaveDeCombate inherits Nave {
	var estadoVisible= true
	var misilesDesplegados= false
	const mensajesEmitidos= []
	
	method ponerseVisible() {estadoVisible= true}
	method ponerseInvisible(){estadoVisible= false}
	method estaInvisible()= estadoVisible
	method desplegarMisiles() {misilesDesplegados= true}
	method replegarMisiles() {misilesDesplegados= false}
	method misilesDesplegados()= misilesDesplegados
	method emitirMensaje(mensaje) {mensajesEmitidos.add(mensaje)}
	method mensajesEmitidos()= mensajesEmitidos.asList()
	method primerMensajeEmitido()= if (mensajesEmitidos.isEmpty()) self.error("No se emitieron mensajes") else mensajesEmitidos.first()
	method ultimoMensajeEmitido()= if (mensajesEmitidos.isEmpty()) self.error("No se emitieron mensajes") else mensajesEmitidos.last()
	method esEscueta()= !mensajesEmitidos.any({mensaje => mensaje.lenght() > 30})
	method emitioMensaje(mensaje)= mensajesEmitidos.find(mensaje)
	override method prepararViaje() {super() self.acelerar(15000) self.ponerseVisible() self.replegarMisiles() self.acelerar(15000) self.emitirMensaje("Saliendo en misión")}
	override method estaTranquila()= super() && !misilesDesplegados
	method escapar() {self.acercarseUnPocoAlSol() self.acercarseUnPocoAlSol() }
	method avisar() {self.emitirMensaje("Amenaza recibida")}
	method recibirAmenaza() {self.escapar() self.avisar()}
	override method tienePocaActividad()= self.esEscueta()
}

class NaveHospital inherits NaveDePasajeros {
	var estanPreparadosLosQuirofanos
	override method estaTranquila()= super() && !estanPreparadosLosQuirofanos
	override method recibirAmenaza() {super() estanPreparadosLosQuirofanos= true}
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
	override method estaTranquila()= super() && estadoVisible
	override method recibirAmenaza() {super() self.desplegarMisiles() self.ponerseInvisible()}
}