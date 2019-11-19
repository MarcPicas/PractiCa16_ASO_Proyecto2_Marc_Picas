#!/bin/bash

# Aquesta Pràctica l'he fet sol ja que el meu company no ha estat venint a ASO últimament i he acordat amb ell que cadascú la faria pel seu compte.

# Assegurat de que l'script és executat amb permissos de superusuari.
if [[ "${UID}" -eq 0 ]]
then
	echo " "
	echo 'Has ejecutdao el comando como superusuario. '
	echo ' '
else
	echo 'Tienes que ejecutar el comando como superusuario.'
	exit 1
fi

# Si l'usuari no proporciona com a mínim un argument, proporciona-li ajuda. 
if [ -n "$1" ]; then 
	echo "Bienvenido,"
else
	echo "ERROR: No has pasado ningún parámetro. "
	exit 1
fi

# El primer paràmetre és el nom d'usuari.
nombre=$1
echo "Tu nombre es: ${nombre}"
echo " "

# La resta de paràmetres s'utilitzaran com a comentaris de la conta.

# Genera una contrasenya.
pass=$(openssl rand -base64 14)
echo "Tu contraseña es: ${pass}"
echo " "

# Crea l'usuari amb la contrasenya.
sudo useradd -p $(openssl passwd -1 ${pass}) -c ${nombre} -m ${nombre}

# Comprova si l'usuari ha sigut creat correctament.
if [ $? -eq 0 ]
then
	echo "Se ha creado el usuario correctamente."
	echo " "
else
	echo "No se ha podido crear el usuario."
	exit 1
fi

# Estableix la contrasenya.
echo ${nombre}":"${pass} | chpasswd

# Comprova que la contrasenya s'hagi creat correctament.
if [ $? -eq 0 ]
then
	echo "Se ha creado la contraseña correctamente."
	echo " "
else
	echo "No se ha podido crear la contraseña."
	exit 1
fi

# Força el canvi de contrasenya al primer login.
echo "Es obligado cambiar la contraseña la primera vez que entras con este usuraio"
chage -d 0 ${nombre}
read -s pass2
echo ${nombre}":"${pass2} | chpasswd

# Mostra el nom usuari, la contrasenya i el host on ha sigut creat l'usuari.
echo "Tu nombre de usuario es: ${nombre}" 
echo "Tu contraseña es: ${pass2}"
echo "El host desde el que lo has creado es: ${HOSTNAME}"
