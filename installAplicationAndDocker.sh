#!/usr/bin/env bash

#-VARIAVEIS INFO-----------------------------------------------------#

NOME_PROGRAMA="$(basename $0 | cut -d. -f1)"
VERSAO="1.0"
AUTOR="Magna Monitoring"
CONTATO="https://github.com/pi-project-adsb/"
DESCRICAO="Script para executar o .jar do projeto"
varEXE=$1 # Se não tiver parametros ela executa normal

#-VARIAVEIS PARAMETRO----------------------------------------------------#

varINFO="
Nome do Programa: $NOME_PROGRAMA
Autor: $AUTOR
Versão: $VERSAO
Descrição do Programa: $DESCRICAO
"
varHELP="
Instruções para Ajuda:
	-h ou --help: Abre a ajuda de comandos do usuário;
	-i ou --info: Informações sobre o programa;
"

#-TESTES--------------------------------------------------------------------------#



#-LOOP PARA RODAR MAIS PARAMETROS---------------------------------------------------#

while test -n "$1"; do

	case $1 in

		-i |  --info)  	echo "$varINFO" 											;;		
		-h |  --help)  	echo "$varHELP"												;;
		-d | --debug)	bash -x $0													;;
		 *) 	echo "\nComando inválido. Digite -h ou --help para ajuda\n"	;;

	esac
	shift

done
#-FUNÇÕES--------------------------------------------------------------------------#

instalar_pacotes(){

	echo "\nInstalando e verificando todos os pacotes...\n"
	sleep 1
	echo "Dando update nos arquivos..."
	sudo apt-get update && sudo apt-get upgrade -y
	echo "Verificando java..."
	[ ! -x $(which java) ] && sudo apt-get install openjdk-11-jdk
	echo "Instalando interface gráfica"
	sudo apt-get install xrdp lxde-core lxde tigervnc-standalone-server -y
	echo "Verificando git..."
	[ ! -x $(which git) ] && sudo apt-get install git-all
	echo "Verificando docker..."
	[ ! -x $(which docker) ] && instalar_docker

}
criar_urubu100(){

	echo "\nCriando usuário urubu100...\n"
	sleep 1
	adduser urubu100
	echo "Dando permissão de sudo para urubu100..."
	usermod -aG sudo urubu100
	

}
clonar_github(){


	echo "\nClonando github e criando pastas...\n"
	wget -O totemSitem.jar https://github.com/pi-project-adsb/magna-aplications/blob/65c37a1ce8c1375698310e6ac608dd42409c3226/data-capture-1.0-SNAPSHOT-jar-with-dependencies.jar 
	echo "Criando uma pasta para o projeto..."
	mkdir magna && mv ./magna.jar magna/magna-aplications.jar && cd magna
	echo "\nTudo pronto...\n"
}
instalar_docker(){

	sudo apt install docker.io
	sudo systemctl start docker
	sudo systemctl enable  docker
	sudo docker pull mysql:latest
	sudo docker run -d -p 3306:3306 --name totemsystem -e "MYSQL_DATABASE=totemsystem" -e "MYSQL_ROOT_PASSWORD=urubu100" mysql:latest
	sudo docker exec -it totemsystem bash
	
}

main(){


	# criar_urubu100
	instalar_pacotes
	clonar_github

}

#-EXECUÇÃO-------------------------------------------------------------------------#

if [ -z "$varEXE" ]; then
	# Coloca o main do programa aqui
	main
fi