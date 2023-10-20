class Nave {
	var velocidad
	var direccion 
	var combustible
	
	method acelerar(cuanto) {velocidad= 100000.min(velocidad += cuanto)}
	method desacelerar(cuanto) {velocidad= 0.max(velocidad -= cuanto)}
	method irHaciaElSol() {direccion= 10}
	method escaparDelSol() {direccion= -10}
	method ponerseParaleloAlSol() {direccion= 0}
	method acercarseUnPocoAlSol() {direccion= 10.min(direccion++)}
	method alejarseUnPocoDelSol() {direccion= -10.max(direccion--)}
	method prepararViaje() {self.cargarCombustible(30000) self.acelerar(5000)}
	
	method cargarCombustible(litros) {combustible += litros}
	method descargarCombustible(litros) {combustible -= litros}
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
	//falta acumulador de raciones de comida servidas
	
	override method prepararViaje() {super() self.racionesDeComida(4 * cantidadDePasajeros) self.bebidas(6 * cantidadDePasajeros)}
	method escapar() {velocidad= velocidad * 2}
	method avisar() {racionesDeComida= (racionesDeComida / cantidadDePasajeros) bebidas= bebidas/ (cantidadDePasajeros/2) }
	method recibirAmenaza() {self.escapar() self.avisar()}
	method racionesDeComida(racion) {racionesDeComida += racion}
	method bebidas(racion) {bebidas += racion}
	override method tienePocaActividad()= racionesDeComidaServidas >= 50
	
}

class NaveDeCombate inherits Nave {
	var estado
	var misiles 
	const mensajesEmitidos= []
	
	method ponerseVisible() {estado= "visible"}
	method ponerseInvisible(){estado= "invisible"}
	method estaInvisible()= estado == "invisible"
	method desplegarMisiles() {misiles= "desplegados"}
	method replegarMisiles() {misiles= "replegados"}
	method misilesDesplegados()= misiles == "desplegados"
	method emitirMensaje(mensaje) {mensajesEmitidos.add(mensaje)}
	method mensajesEmitidos()= mensajesEmitidos.asList()
	method primerMensajeEmitido()= mensajesEmitidos.first()
	method ultimoMensajeEmitido()= mensajesEmitidos.last()
	method esEscueta()= !mensajesEmitidos.any({mensaje => mensaje.lenght() > 30})
	method emitioMensaje(mensaje)= mensajesEmitidos.find(mensaje)
	override method prepararViaje() {super() self.acelerar(15000) self.ponerseVisible() self.replegarMisiles() self.acelerar(15000) self.emitirMensaje("Saliendo en misión")}
	override method estaTranquila()= super() && misiles == "replegados"
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
	override method estaTranquila()= super() && estado == "visible"
	override method recibirAmenaza() {super() self.desplegarMisiles() self.ponerseInvisible()}
}