#!/usr/bin/env bash

#-VARIAVEIS INFO-----------------------------------------------------#

AUTOR="Magna Monitoring"
VERSAO="1.0"
CONTATO="https://github.com/pi-project-adsb/"
DESCRICAO="Script para executar o .jar do projeto"
varEXE=$1

#-FUNÇÕES--------------------------------------------------------------------------#

installPackagesAndGUI() {
	echo "Instalando e atualizando todos os pacotes"
	sudo apt-get update && sudo apt-get upgrade -y
	echo "Verificando java"
	[ ! -x $(which java) ] && sudo apt-get install openjdk-11-jdk
	echo "Instalando interface gráfica"
	sudo apt-get install xrdp lxde-core lxde tigervnc-standalone-server -y
	echo "Verificando git"
	[ ! -x $(which git) ] && sudo apt-get install git-all
}

createUserUrubu100() {
	echo "Criando senha para usuario ubuntu"
	sudo passwd ubuntu
	echo "Criando usuário urubu100"
	sudo adduser urubu100
	echo "Dando permissão de sudo para urubu100"
	sudo usermod -aG sudo urubu100
}

cloneGithub() {
	echo "Clonando github"
	git clone https://github.com/pi-project-adsb/magna-aplications.git
	cd magna-aplications
}

installDocker() {	
	echo "Verificando docker"
	[ ! -x $(which docker) ] && installDocker
	echo "\n Instalando os pacotes do docker \n"
	sudo apt install docker.io
	echo "Iniciando o serviço do docker"
	sudo systemctl start docker
	sudo systemctl enable docker
	echo "Criando network"
	sudo docker network create java_mysql
	cd mysql
	echo "Criando imagem e container do database MySql"
	dockerMySql
	cd ..
	cd java
	echo "Criando imagem e container da aplicação Java"
	dockerDataCapture

	#systemctl = inicia serviço
}

dockerMySql() {
	sudo docker build -t mysql_magna .
	sudo docker run -d -p 3306:3306 --name magnaSQL --net=java_mysql -e "MYSQL_ROOT_PASSWORD=urubu100" mysql_magna
	#-d = dessasociar do terminal (deixar de rodar apenas no terminal, deixa rodando em background)
	#-p = set a porta
	#recebe a requisicao do docker e depois da maquina
	#executa um comando -t = comando interativo; magna bash = entre no terminal, de modo interativo

}

dockerDataCapture() {
	sudo docker build -t data_capture_magna .
	sudo docker run -it --name data_capture_java --link magnaSQL --net=java_mysql data_capture_magna
	#executa um comando -t = comando interativo; magna bash = entre no terminal, de modo interativo

}

main() {
	createUserUrubu100
	#clear
	installPackagesAndGUI
	#clear
	cloneGithub
	#clear
	installDocker
}

#-EXECUÇÃO-------------------------------------------------------------------------#

if [ -z "$varEXE" ]; then
	main
fi
