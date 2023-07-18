class MetaHumano inherits Personaje{
	
	override method capacidadesDeBatalla()=super()*2
	
	override method esInmune()=true
	
	override method ganaPuntos(peligro){
		super(peligro)
		espiritualidad+=peligro.nivelDeComplejidad()
	}
	
	
}
class Mago inherits MetaHumano{
	var property poderAcumulado
	
	
	override method capacidadesDeBatalla()=super()+poderAcumulado
	
	override method ganaPuntos(peligro){
		if(poderAcumulado>10){
			super(peligro)
		}
		if (poderAcumulado < 5) {
			poderAcumulado = 0
		} else {
			poderAcumulado-=5
		}
	}
	
}


class Personaje{
	var property estrategia=0
	var property espiritualidad=0
	var property poderes=[]

	method capacidadesDeBatalla()=poderes.sum({poder=>poder.capacidadDeBatalla(self)})
	
	method capacidadDeBatallaDe(poder)=poder.capacidadDeBatalla(self)
	
	method mejorPoder()=poderes.max({poder=>poder.capacidadDeBatalla(self)})
	
	method esInmune()=poderes.any({poder=>poder.inmunidad(self)})
	
	method puedeEnfrentar(peligro)= self.capacidadSuficiente(peligro) and self.validoRadio(peligro)

	method capacidadSuficiente(peligro)=self.capacidadesDeBatalla() > peligro.capacidadDeBatalla()
	
	method ganaPuntos(peligro){estrategia+=peligro.nivelDeComplejidad()}

	method validoRadio(peligro){
		if (peligro.desechosRadio()){
			return self.esInmune()
		}else{
			return true
		}
	}
	
	method validoEnfretamiento(peligro){
		if(not self.puedeEnfrentar(peligro)){
			throw new Exception(message = "no puede")
			
		}
	}
	
	method enfrentarPeligro(peligro){
		if(self.puedeEnfrentar(peligro)){
			self.ganaPuntos(peligro)
			
		}else{self.validoEnfretamiento(peligro)}

	}
}
class Equipo {
	var property miembros=[]
	
	
	method masVulnerable()=miembros.min({pj=>pj.capacidadesDeBatalla()})
	
	method calidadDeBatalla()= (self.sumaDeCapacidades()).div(self.cantidadDeMiembros())
	
	method sumaDeCapacidades()=miembros.sum({pj=>pj.capacidadesDeBatalla()})
	
	method cantidadDeMiembros()= miembros.size()
	
	method mejoresPoderes()=miembros.map({miembro=>miembro.mejorPoder()})
	
	method esSensato(peligro)=miembros.all({pj=>pj.puedeEnfrentar(peligro)})
	
	method quienesPuedenContra(peligro)=miembros.filter({pj=>pj.puedeEnfrentar(peligro)})
	
	method cantidadDeMiembrosVs(peligro)= (self.quienesPuedenContra(peligro)).size()

	method condicionDePelea(peligro)=peligro.cantidadQueSeBanca()<self.cantidadDeMiembrosVs(peligro)
	
	method miembrosEnfrentarPeligro(peligro){
		if(self.condicionDePelea(peligro)){
			self.quienesPuedenContra(peligro).forEach({pj=>pj.enfrentarPeligro(peligro)})
		}else{self.validoSiNoPueden(peligro)}
	}
	
	method validoSiNoPueden(peligro){
		
		if(not self.condicionDePelea(peligro)){
			throw new Exception(message = "no puede")
		}else{}
	}
	
	
}



class Peligro {
	var property capacidadDeBatalla
	var property desechosRadio
	var property nivelDeComplejidad
	var property cantidadQueSeBanca
	
	
	
}
class Poder {
	
	method capacidadDeBatalla(pj)= (self.agilidad(pj) + self.fuerza(pj)) * self.habilidadExpecial(pj)

	method agilidad(pj)=pj.estrategia() 
	
	method fuerza(pj)=pj.espiritualidad()
	
	method habilidadExpecial(pj)=pj.estrategia()+pj.espiritualidad()
	
	method inmunidad(pj)=false
	
}


class PoderVelocidad inherits Poder{
	var property rapidez
	override method agilidad(pj)=super(pj) *rapidez
	
	override method fuerza(pj)=super(pj)*rapidez
	
	
}


class PoderVuelo inherits Poder{
	var property alturaMaxima
	var property energia
	
	override method agilidad(pj)=(super(pj)*self.alturaMaxima())/energia

	override method fuerza(pj)=(super(pj)+self.alturaMaxima())-energia
	
	override method inmunidad(pj)=alturaMaxima>200
	
}

class PoderAmplificador inherits Poder{
	var property poderBase
	var property amplificador
	override method  agilidad(pj)=poderBase.agilidad(pj)
	
	override method  fuerza(pj)=poderBase.fuerza(pj)
	
	override method  habilidadExpecial(pj)=super(pj)*amplificador
	
	override method inmunidad(pj)= true
	
}