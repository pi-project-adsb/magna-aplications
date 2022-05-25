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

	-i | --info) echo "$varINFO" ;;
	-h | --help) echo "$varHELP" ;;
	-d | --debug) bash -x $0 ;;
	*) echo "\n Comando inválido. Digite -h ou --help para ajuda \n" ;;

	esac
	shift

done
#-FUNÇÕES--------------------------------------------------------------------------#

installPackagesAndGUI() {
	echo "\n Instalando e atualizando todos os pacotes \n"
	sudo apt-get update && sudo apt-get upgrade -y
	echo "Verificando java"
	[ ! -x $(which java) ] && sudo apt-get install openjdk-11-jdk
	echo "Instalando interface gráfica"
	sudo apt-get install xrdp lxde-core lxde tigervnc-standalone-server -y
	echo "Verificando git"
	[ ! -x $(which git) ] && sudo apt-get install git-all
}

createUserUrubu100() {
	echo "\n Criando senha para usuario ubuntu \n"
	sudo passwd ubuntu
	echo "\n Criando usuário urubu100 \n"
	sudo adduser urubu100
	echo "Dando permissão de sudo para urubu100"
	sudo usermod -aG sudo urubu100
	echo "Trocando para usuario urubu100 "
	su urubu100

}

cloneGithub() {
	cd ~
	cd home
	cd urubu100
	echo "\n Clonando github \n"
	git clone https://github.com/pi-project-adsb/magna-aplications.git
	cd magna-aplications

}

installDocker() {	
	echo "Verificando docker"
	[ ! -x $(which docker) ] && installDocker
	echo "\n Instalando os pacotes do docker \n"
	sudo apt install docker.io
	#systemctl = inicia serviço
	echo "Iniciando o serviço do docker"
	sudo systemctl start docker
	sudo systemctl enable docker
	echo "Criando network"
	sudo docker network create java_mysql
	cd mysql
	echo "Criando imagem e container do database MySql"
	docker_mysql
	cd ..
	cd java
	echo "Criando imagem e container da aplicação Java"
	docker_data_capture
}

docker_mysql() {
	#-d = dessasociar do terminal (deixar de rodar apenas no terminal, deixa rodando em background)
	#-p = set a porta
	sudo docker build -t mysql_magna .
	#recebe a requisicao do docker e depois da maquina
	sudo docker run -d -p 3306:3306 --name magnaSQL --net=java_mysql -e "MYSQL_ROOT_PASSWORD=urubu100" mysql_magna
	#executa um comando -t = comando interativo; magna bash = entre no terminal, de modo interativo
	#sudo docker exec -it magnaSQL bash

}

docker_data_capture() {
	sudo docker build -t data_capture_magna .
	sudo docker run -it --name data_capture_java --link magnaSQL --net=java_mysql data_capture_magna
	#executa um comando -t = comando interativo; magna bash = entre no terminal, de modo interativo
	#sudo docker exec -it data_capture_java bash

}

main() {
	createUserUrubu100
	clear
	installPackagesAndGUI
	clear
	cloneGithub
	clear
	installDocker
}

#-EXECUÇÃO-------------------------------------------------------------------------#

if [ -z "$varEXE" ]; then
	# Coloca o main do programa aqui
	main
fi
