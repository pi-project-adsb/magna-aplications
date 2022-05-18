#!/usr/bin/env bash

#-VARIAVEIS INFO-----------------------------------------------------#

NOME_PROGRAMA="$(basename $0 | cut -d. -f1)"
VERSAO="1.0"
AUTOR="Lucaszib"
CONTATO="https://github.com/Lucaszib"
DESCRICAO="Modelo base para outros scripts shellscript"
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
magnaJavaInstall() {
	echo  "$(tput setaf 10)[MAGNA]:$(tput setaf 7)  ASSISTENTE DE INSTALAÇÃO - MAGNA;"
	sleep 2

	echo  "$(tput setaf 10)[MAGNA]:$(tput setaf 7)  Verificando se o Java está instalado..."
	sleep 2

	java -version
	if [ $? -eq 0 ]
			then
					echo "$(tput setaf 10)[MAGNA]:$(tput setaf 7) : Java já instalado."
					sleep 2
			else
					echo "$(tput setaf 10)[MAGNA]:$(tput setaf 7)  Java não encontrado, deseja instalar? Digite 'y' para sim"
					sleep 2        
			read inst
			if [ \"$inst\" == \"Y\" ]
					then
						echo "$(tput setaf 10)[MAGNA]:$(tput setaf 7)  Adicionando o repositório..."
						sleep 2
						sudo add-apt-repository ppa:webupd8team/java -y
						clear
						echo "$(tput setaf 10)[MAGNA]:$(tput setaf 7)  Atualizando Pacotes..."
						sleep 2
						sudo apt update -y
						clear

							if [ $VERSAO -eq 11 ]
									then
											echo "$(tput setaf 10)[MAGNA]:$(tput setaf 7) Preparando instalação do Java 11..."
											sleep 1
											sudo apt install default-jre ; apt install openjdk-11-jre-headless; -y
											clear
											echo "$(tput setaf 10)[MAGNA]:$(tput setaf 7) Java instalado com sucesso!"
											sleep 1
									fi
					else
					echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Você optou por não instalar o Java por enquanto, até a próxima então!"
					sleep 1
			fi
	fi
}

#-EXECUÇÃO------------------------------------------------------------------------#

if [ -z "$varEXE" ]; then
	magnaJavaInstall
fi