import csv
import sys
from os import listdir
from os.path import isfile, join
import matplotlib.pyplot as plt
import numpy as np

def cVsAsm():
	fileOcero = '0.salida.caso.C.O0.1024.txt' 
	fileOtres = '0.salida.caso.C.O3.1024.txt'
	fileASM =   '1.salida.caso.asm.1024.txt'

	file = open(fileOcero, "r")
	valuesOcero = [int(i) for i in file.readlines()]
	indexesOcero = [i for i in range(100)]
	maxValueOcero = max(valuesOcero)
	minValueOcero = min(valuesOcero)
	promedioOcero = np.mean(valuesOcero)
	desvioOcero = np.std(valuesOcero)

	file = open(fileOtres, "r")
	valuesOtres = [int(i) for i in file.readlines()]
	indexesOtres = [i for i in range(100)]
	maxValueOtres = max(valuesOtres)
	minValueOtres = min(valuesOtres)
	promedioOtres = np.mean(valuesOtres)
	desvioOtres = np.std(valuesOtres)

	file = open(fileASM, "r")
	valuesASM = [int(i) for i in file.readlines()]
	indexesASM = [i for i in range(100)]
	maxValueASM = max(valuesASM)
	minValueASM = min(valuesASM)
	promedioASM = np.mean(valuesASM)
	desvioASM = np.std(valuesASM)

	# Esto comentado es si queres graficar el minimo

	#	y = []
	#	y.append(minValueOcero)
	#	y.append(minValueOtres)
	#	y.append(minValueASM)

	#	ind = np.arange(1,4) 
	#	width = .75     

	#	fig, ax = plt.subplots()
	#	rects1 = ax.bar(ind, y, width)

	#	ax.set_ylabel('Ciclos')
	#	ax.set_title('Comparacion de cantidad de ciclos entre ASM y distintas optimizaciones de C')
		#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
	#	ax.set_xticks(ind + 0.4)
	#	ax.set_xticklabels(('C-O0','C-O3','ASM'))
	#	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	#	rects1[0].set_color('g')
	#	rects1[1].set_color('b')
	#	rects1[2].set_color('r')
		#plt.ylim(0, 102500000)
	#	plt.show()

	y = []
	y.append(promedioOcero)
	y.append(promedioOtres)
	y.append(promedioASM)
	stdy = []
	stdy.append(desvioOcero)
	stdy.append(desvioOtres)
	stdy.append(desvioASM)

	ind = np.arange(1,4) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stdy,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))

	ax.set_ylabel('Ciclos de clock')
	ax.set_title('Comparacion de performance entre C-O0, C-O3 y ASM')
	#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
	ax.set_xticks(ind + 0.4)
	ax.set_xticklabels(('C-O0','C-O3','ASM'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('g')
	rects1[1].set_color('b')
	rects1[2].set_color('r')
	plt.show()
		

	y = []
	y.append(promedioOtres)
	y.append(promedioASM)
	stdy = []
	stdy.append(desvioOtres)
	stdy.append(desvioASM)

	ind = np.arange(1,3) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stdy,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))

	ax.set_ylabel('Ciclos de clock')
	ax.set_title('Comparacion de performance entre C-O3 y ASM')
	#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
	ax.set_xticks(ind + 0.4)
	ax.set_xticklabels(('C-O3','ASM'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('b')
	rects1[1].set_color('r')
	plt.show()

def cVsAsmMin():
	fileOcero = '6.salida.caso.C.O0.txt' 
	fileOtres = '6.salida.caso.C.O3.txt'
	fileASM =   '1.salida.caso.asm.1024.txt'
	file = open(fileOcero, "r")
	valuesOcero = sorted([int(i) for i in file.readlines()])[0:90]
	indexesOcero = [i for i in range(100)]
	maxValueOcero = max(valuesOcero)
	minValueOcero = float(min(valuesOcero))
	promedioOcero = float(np.mean(valuesOcero))
	desvioOcero = np.std(valuesOcero)

	file = open(fileOtres, "r")
	valuesOtres = sorted([int(i) for i in file.readlines()])[0:90]
	indexesOtres = [i for i in range(100)]
	maxValueOtres = max(valuesOtres)
	minValueOtres = float(min(valuesOtres))
	promedioOtres = float(np.mean(valuesOtres))
	desvioOtres = np.std(valuesOtres)
	
	file = open(fileASM, "r")
	valuesASM = sorted([int(i) for i in file.readlines()])[0:90]
	indexesASM = [i for i in range(100)]
	maxValueASM = max(valuesASM)
	minValueASM = float(min(valuesASM))
	promedioASM = float(np.mean(valuesASM))
	desvioASM = np.std(valuesASM)

	# Esto comentado es si queres graficar el minimo
	y = []
	y.append(minValueOcero/minValueOtres)
	y.append(minValueOtres/minValueOtres)
	y.append(minValueASM/minValueOtres)
	stdy = []
	stdy.append(promedioOcero/minValueOtres - y[0])
	stdy.append(promedioOtres/minValueOtres - y[1])
	stdy.append(promedioASM/minValueOtres - y[2])
	stds    = [(0,0,0), stdy]
	print y, stds

	ind = np.arange(1,4) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stds,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))
	
	ax.set_ylabel('Cantidad ciclos de clock en comparacion con C-O3')
	ax.set_title('Comparacion de performance entre ASM y C')
		#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
	ax.set_xticks(ind + 0.375)
	ax.set_xticklabels(('C-O0','C-O3','ASM'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('g')
	rects1[1].set_color('b')
	rects1[2].set_color('r')
		#plt.ylim(0, 102500000)
	plt.show()

	y = []
	y.append(minValueOtres/minValueOtres)
	y.append(minValueASM/minValueOtres)
	stdy = []
	stdy.append(promedioOtres/minValueOtres - y[0])
	stdy.append(promedioASM/minValueOtres - y[1])
	stds    = [(0,0), stdy]
	print y, stds

	ind = np.arange(1,3) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stds,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))
	
	ax.set_ylabel('Cantidad ciclos de clock en comparacion con C-O3')
	ax.set_title('Comparacion de performance entre ASM y C')
		#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
	ax.set_xticks(ind + 0.375)
	ax.set_xticklabels(('C-O3','ASM'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('b')
	rects1[1].set_color('r')
		#plt.ylim(0, 102500000)
	plt.show()


def Asm1VsAsm2(file1, file2):
	file = open(file1, "r")
	#este es el orginal, me lo copie de otro lado y por eso quedaron asi las variables
	valuesOcero = sorted([int(i) for i in file.readlines()])[0:90]
	indexesOcero = [i for i in range(100)]
	maxValueOcero = max(valuesOcero)
	minValueOcero = float(min(valuesOcero))
	promedioOcero = float(np.mean(valuesOcero))
	desvioOcero = np.std(valuesOcero)

	file = open(file2, "r")
	valuesASM = sorted([int(i) for i in file.readlines()])[0:90]
	indexesASM = [i for i in range(100)]
	maxValueASM = max(valuesASM)
	minValueASM = float(min(valuesASM))
	promedioASM = float(np.mean(valuesASM))
	desvioASM = np.std(valuesASM)

	y = []
	y.append(minValueOcero/minValueOcero)
	y.append(minValueASM/minValueOcero)

	stdy = []
	stdy.append(promedioOcero/promedioOcero - y[0])
	stdy.append(promedioASM/promedioOcero - y[1])
	stds    = [(0,0), stdy]
	print y, stds

	ind = np.arange(1,3) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stds,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))
	
	ax.set_ylabel('Cantidad ciclos de clock en comparacion la version original')
	ax.set_title('Comparacion de performance entre dos implementaciones de ASM')
		#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
	ax.set_xticks(ind + 0.375)
	ax.set_xticklabels(('ASM','ASM Alternativo'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('b')
	rects1[1].set_color('r')
	plt.ylim(0, 1.3)
	plt.show()

def Asm1VsAsm2PorPixel():
	filewrite2 = '1.salida.caso.asm.64.txt' 
	filewrite4 = '1.salida.caso.asm.alternativo.64.txt'
	file = open(filewrite2, "r")
	valueswrite2 = sorted([int(i) for i in file.readlines()])[0:90]
	indexeswrite2 = [i for i in range(100)]
	maxValuewrite2 = np.max(valueswrite2)
	minValuewrite2 = float(np.min(valueswrite2))
	promediowrite2 = np.mean(valueswrite2)
	desviowrite2 = np.std(valueswrite2)
	file = open(filewrite4, "r")
	valueswrite4 = sorted([int(i) for i in file.readlines()])[0:90]
	indexeswrite4 = [i for i in range(100)]
	maxValuewrite4 = np.max(valueswrite4)
	minValuewrite4 = float(np.min(valueswrite4))
	promediowrite4 = np.mean(valueswrite4)
	desviowrite4 = np.std(valueswrite4)

	filewrite2_1024 = '1.salida.caso.asm.256.txt' 
	filewrite4_1024 = '1.salida.caso.asm.alternativo.256.txt'

	file = open(filewrite2_1024, "r")
	valueswrite2_1024 = sorted([int(i) for i in file.readlines()])[0:90]
	indexeswrite2_1024 = [i for i in range(100)]
	maxValuewrite2_1024 = np.max(valueswrite2_1024)
	minValuewrite2_1024 = float(np.min(valueswrite2_1024))
	promediowrite2_1024 = np.mean(valueswrite2_1024)
	desviowrite2_1024 = np.std(valueswrite2_1024)
	file = open(filewrite4_1024, "r")
	valueswrite4_1024 = sorted([int(i) for i in file.readlines()])[0:90]
	indexeswrite4_1024 = [i for i in range(100)]
	maxValuewrite4_1024 = np.max(valueswrite4_1024)
	minValuewrite4_1024 = float(np.min(valueswrite4_1024))
	promediowrite4_1024 = np.mean(valueswrite4_1024)
	desviowrite4_1024 = np.std(valueswrite4_1024)

	filewrite2_2048 = '1.salida.caso.asm.1024.txt' 
	filewrite4_2048 = '1.salida.caso.asm.alternativo.1024.txt'

	file = open(filewrite2_2048, "r")
	valueswrite2_2048 = sorted([int(i) for i in file.readlines()])[0:90]
	indexeswrite2_2048 = [i for i in range(100)]
	maxValuewrite2_2048 = np.max(valueswrite2_2048)
	minValuewrite2_2048 = float(np.min(valueswrite2_2048))
	promediowrite2_2048 = np.mean(valueswrite2_2048)
	desviowrite2_2048 = np.std(valueswrite2_2048)
	file = open(filewrite4_2048, "r")
	valueswrite4_2048 = sorted([int(i) for i in file.readlines()])[0:90]
	indexeswrite4_2048 = [i for i in range(100)]
	maxValuewrite4_2048 = np.max(valueswrite4_2048)
	minValuewrite4_2048 = float(np.min(valueswrite4_2048))
	promediowrite4_2048 = np.mean(valueswrite4_2048)
	desviowrite4_2048 = np.std(valueswrite4_2048)

	cantPix512 = 512*512
	cantPix1024 = 1024*1024
	cantPix2048 = 2048*2048

	y = []
	y.append(minValuewrite2/cantPix512)
	y.append(minValuewrite4/cantPix512)
	y.append(minValuewrite2_1024/cantPix1024)
	y.append(minValuewrite4_1024/cantPix1024)
	y.append(minValuewrite2_2048/cantPix2048)
	y.append(minValuewrite4_2048/cantPix2048)
	stdy = []
	stdy.append(promediowrite2/cantPix512 - y[0])
	stdy.append(promediowrite4/cantPix512 - y[1])
	stdy.append(promediowrite2_1024/cantPix1024 - y[2])
	stdy.append(promediowrite4_1024/cantPix1024 - y[3])
	stdy.append(promediowrite2_2048/cantPix2048 - y[4])
	stdy.append(promediowrite4_2048/cantPix2048 - y[5])
	print y, stdy
	stds    = [(0,0,0,0,0,0), stdy]
	ind = np.arange(1,7) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stds,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))

	ax.set_ylabel('Ciclos de clock en comparacion con Write2')
	ax.set_xticks(ind + 0.4)
	ax.set_xticklabels(('Write2 \n 512x512','Write4 \n 512x512', 'Write2 \n 1024x1024','Write4 \n 1024x1024','Write2 \n 2048x2048','Write4 \n 2048x2048'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('g')
	rects1[1].set_color('b')
	rects1[2].set_color('g')
	rects1[3].set_color('b')
	rects1[4].set_color('g')
	rects1[5].set_color('b')
	plt.show()

def main():
	#cVsAsm()
	#cVsAsmMin()
	Asm1VsAsm2('1.salida.caso.asm.1024.txt','1.salida.caso.asm.alternativo.1024.txt')
	#Asm1VsAsm2('1.salida.caso.asm.256.txt','1.salida.caso.asm.alternativo.256.txt')
	#Asm1VsAsm2('1.salida.caso.asm.64.txt','1.salida.caso.asm.alternativo.64.txt')
	#Asm1VsAsm2PorPixel()
if __name__ == "__main__":
	main()