#!/bin/bash
## Script para criar PDF a partir de HTML

empresa=$1
variavel='Valores'

echo "<!DOCTYPE html>
<html lang='pt-br'>
	<head>
		<meta charset='utf-8'/>
		<link rel='stylesheet' type='text/css' href='style.css'>
		<title>Relatório</title>
	</head>
	<body>" > relatorio.html
echo "	<h1><br><br><br><img src='helpers/logo.png' width='300'><br><br><br><br><br></h1>" >> relatorio.html
echo "	<h1>Estudo - "$empresa"</h1>" >> relatorio.html
echo "	<h3 class='titulo'>Tópico</h3>" >> relatorio.html
echo "	<p>Esse relatório é sobre a empresa " $empresa":</p>" >> relatorio.html
echo "	<ul>" >> relatorio.html
echo "	<li>item 1</li>" >> relatorio.html
echo "	<li>item 2</li>" >> relatorio.html
echo "	<li>item 3</li>" >> relatorio.html
echo "	</ul>" >> relatorio.html
echo "	<p>Veja a tabela a seguir:</p>" >> relatorio.html
# Converter CSV de coeficientes para HTML
print_header=false
nt=1
for file in `ls output/*/Coeficientes.csv`; do
	lugar=$(echo $file | awk -F'/' '{print $3}' | awk -F'_' '{print $1}')
	tipo=$(echo $file | awk -F'/' '{print $2}' | tr [a-z] [A-Z])
	echo "<div class='tabela'>" >> relatorio.html
	echo "<table>" >> relatorio.html
	while read INPUT ; do
	  if $print_header;then
	    echo "<tr><th>$INPUT" | sed -e 's/:[^,]*\(,\|$\)/<\/th><th>/g' >> relatorio.html
	    print_header=false
	  fi
	  echo "<tr><td>${INPUT//,/</td><td>}</td></tr>"  >> relatorio.html
	done < $file ;
	echo "</table>" >> relatorio.html
	echo "</div>" >> relatorio.html
	echo "<p class='subtabela'>Tabela "$nt" - números aleatórios entre 0 e 1</p>" >> relatorio.html
	nt=$(($nt+1))
done
# Fim de impressão de tabelas
echo "	<p>Aqui vai um texto bem supimpa.</p>" >> relatorio.html
echo "	<h3 class='titulo'>Outro tópico</h3>" >> relatorio.html
echo "	<p>Mais um texto prafrentex.</p>" >> relatorio.html
nf=1
# Lista de figuras
for file in `ls output/*/*.png`; do
	lugar=$(echo $file | awk -F'/' '{print $3}' | awk -F'_' '{print $1}')
	tipo=$(echo $file | awk -F'/' '{print $2}')
	regressores=$(echo $file | awk -F'/' '{print $3}' | awk -F'_' '{print $2}' | awk -F'.' '{print $1}')
	# Imprimir figura
	echo "	<figure>
			<img src='"$file"'>
			<figcaption>Fig. "$nf" - Valores em" $lugar": números aleatórios</figcaption>
			</figure>" >> relatorio.html
	nf=$(($nf+1))
done
echo "	</body>
</html>" >> relatorio.html

/usr/bin/wkhtmltopdf -B 20 -L 20 -R 20 -T 20 relatorio.html relatorio.pdf
