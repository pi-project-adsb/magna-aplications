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

instalar_pacotes() {
	echo "\n Instalando e verificando todos os pacotes... \n"
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

criar_urubu100() {
	echo "\n Criando usuário urubu100... \n"
	sleep 1
	adduser urubu100
	echo "Dando permissão de sudo para urubu100..."
	usermod -aG sudo urubu100
}

clonar_github() {
	echo "\n Clonando github e criando pastas... \n"
	git clone https://github.com/pi-project-adsb/magna-aplications.git
	cd magna-aplications
	chmod +x installAplicationAndDocker.sh

}

rodando_aplicacao() {
	echo "Rodando a aplicacao..."
	clear
	echo "\n Tudo pronto... \n"
	echo "\n Gostaria de rodar nossa aplicação? \n"
	read run
	#if [ \"$run\" == \"Y\"] || [ \"$run\" == \"y\"]; then
		java -jar data-capture-1.0-SNAPSHOT-jar-with-dependencies.jar
	#else
		#echo "\nEntao ta, nos vemos na próxima!\n"

	#fi
}

install_docker() {
	sudo apt install docker.io
	#systemctl = inicia serviço
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo docker network create java_mysql

	cd magna-aplications
	cd mysql
	docker_mysql
	cd ..
	cd java
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
	#sudo docker exec -it magnaSQL bash

}

main() {

	instalar_pacotes
	clonar_github
	install_docker

}

#-EXECUÇÃO-------------------------------------------------------------------------#

if [ -z "$varEXE" ]; then
	# Coloca o main do programa aqui
	main
fi
