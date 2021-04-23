#!/bin/sh
# GMT script for plotting seismicity map .
# Leonardo Alvarado 2020
# Files required:
# 1. datos.txt epicentro de sismos
# 2. fallas2015.text
# 3. verde.cpt  paleta de colores para topografía
# 4. frontera_marinas.txt y frontera0.txt (archivo de fronteras Trinidad y Aruba Bonaire islas)
# 5. mecanismos.txt mecanismos focales
# 6. legend_magnitud.txt archivo con legenda de la magnitud


r="-74/-59/5/14"
proj="m1:10000000"
ps="sismicidad.ps"
datos="datos.txt"

pscoast -R$r -J$proj -Df -W1 -G255/255/190 -S176/216/230 -Ba2f1/a2f1:."": -Na -N1/2 -X1.0 -Y5.0 -K -V -P > $ps
grdimage etopo1_bedrock.grd -R$r -J$proj -Cverde.cpt -E50 -O -K >> $ps
pscoast -Jm -R -Df -C195/255/255  -Na -I2/0.25p,deepskyblue4 -I3/0.25,deepskyblue4 -Bg500 -K -O >> $ps
pscoast -R -Jm -W -Df -O -K  -T-60.1/12.2/2.0/3.0  >> $ps
#-Lf-65/6.5/6.5/100

#TEXTO
pstext -R$r -J$proj -F+f20p,Helvetica-Bold,white -O -V -K <<END >> $ps
-66.00 13.2  Mar Caribe
END

# FALLAS
psxy  fallas2015.txt -J$proj -R$r -W0.5,red -O -V -K  >> $ps

#FRONTERAS MARINAS
psxy  fronteras_marinas.txt -J$proj -R$r -W1,white,- -O -V -K  >> $ps
psxy  frontera0.txt -J$proj -R$r -W0.5,white,- -O -V -K  >> $ps

#SISMOS POR RANGODE MAGNITUD
awk '$12 <  3.0  {print $8, $7}'  $datos | psxy -J$proj -R$r -Sc0.20 -G0/255/0 -W -O -K -h1 >> $ps
awk '$12 >= 3.0 && $13 < 4.0 {print $8, $7}'  $datos | psxy -J$proj -R$r -Sc0.25 -G0/255/255 -W -O -K -h1 >> $ps
awk '$12 >= 4.0 && $13 < 5.0 {print $8, $7}'  $datos | psxy -J$proj -R$r -Sc0.30 -G255/255/0 -W -O -K -h1 >> $ps
awk '$12 >= 5.0 {print $8, $7}'  $datos | psxy -J$proj -R$r -Sc0.40 -G255/0/0 -W -O  -K -h1 >> $ps

#MECANISMOS FOCALES
gawk '{print $0}' mecanismos.txt | psmeca  -R$r  -J$proj -O -V -K -Sa0.8  -h1 -G0 -C -W0.1  >> $ps

# LEYENDA
pslegend legend_magnitud.txt -R$r -J$proj -O -DjBR+w3.4/3.4 -F+pthick+ithinner+gwhite --FONT_ANNOT_PRIMARY=8p,Helvetica >> $ps

#Leyenda incluida
#pslegend -R$r -J$proj -O -DjBR+w3.4/3.4 -F+pthick+ithinner+gwhite --FONT_ANNOT_PRIMARY=8p,Helvetica << EOF >> $ps
#H 8 1 Magnitud
#D 0.2c 0.5p
#G 0.14c
#S 0.25c c 0.38c red    thin 0.7c mayor o igual a 5,0
#G 0.14c
#S 0.25c c 0.32c yellow thin 0.7c entre 4,0 y 4,9
#G 0.14c
#S 0.25c c 0.28c cyan  thin 0.7c entre 3,0 y 3,9
#G 0.14c
#S 0.25c c 0.23c green thin 0.7c menor a 3,0
#G 0.20c
#M 1 1 200+u
#EOF

#echo -62.0  4.9 > cuadro
#echo -62.0  7.2 >> cuadro
#echo -59.0  7.2 >> cuadro
#echo -59.0  4.9 >> cuadro
#psxy cuadro  -R -Jm -G255 -W1 -O -V -K  >> $ps
#rm cuadro
#
## mayor 5
#echo -61.70 6.45 | psxy -R -Jm -Sc0.40 -G255/0/0 -W1 -O -V -K >> $ps
#
## 4-4.9
#echo -61.70 6.05 | psxy -R -Jm -Sc0.35 -G255/255/0 -W1  -O -V -K >> $ps
#
## 3-3.9
#echo -61.70 5.65 | psxy -R -Jm -Sc0.30 -G0/255/255 -W1 -O -V -K >> $ps
#
## <3
#echo -61.70 5.25 | psxy -R -Jm -Sc0.20 -G0/255/0 -W1 -O -V -K >> $ps
#
#
#echo -61.80  6.85  MAGNITUD \(Mw\) | pstext -F+f10p,Helvetica,+jBL -R -Jm -O -V -K >> $ps
#echo -61.45  6.4  mayor o igual 5,0  | pstext -F+f9p,Helvetica,+jBL -R -Jm -O -V -K >> $ps
#echo -61.45  6.0  entre 4,0 - 4,9  | pstext -F+f9p,Helvetica,+jBL -R -Jm -O -V -K >> $ps
#echo -61.45  5.6  entre 3,0 - 3,9  | pstext -F+f9p,Helvetica,+jBL -R -Jm -O -V -K >> $ps
#echo -61.45  5.2  menor a 3,0  | pstext -F+f9p,Helvetica,+jBL -R -Jm -O -V >> $ps
#echo -62.3  5.2  10 0 7 1 Falla Geol.  | pstext -R -Jm -O -V >> $ps

ps2eps -f $ps
convert -density 240 sismicidad.eps -trim -flatten sismicidad.png
rm *.ps
#rm *.eps
#evince $ps
