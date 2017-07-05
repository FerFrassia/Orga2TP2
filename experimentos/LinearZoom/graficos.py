import csv
import sys
from os import listdir
from os.path import isfile, join
import matplotlib.pyplot as plt
import numpy as np

def cVsAsm():
	fileOcero = '0.salida.caso. Linear Zoom C O0.txt' 
	fileOtres = '0.salida.caso.Linear Zoom C O3.txt'
	fileASM =   '1.salida.caso.write2.txt'

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

def write2vs4Absoluto():
	filewrite2 = '1.salida.caso.write2.txt' 
	filewrite4 = '1.salida.caso.write4.txt'

	file = open(filewrite2, "r")
	valueswrite2 = sorted([int(i) for i in file.readlines()])[0:90]

	indexeswrite2 = [i for i in range(100)]
	maxValuewrite2 = np.max(valueswrite2)
	minValuewrite2 = np.min(valueswrite2)
	promediowrite2 = np.mean(valueswrite2)
	desviowrite2 = np.std(valueswrite2)


	file = open(filewrite4, "r")
	valueswrite4 = sorted([int(i) for i in file.readlines()])[0:90]
	indexeswrite4 = [i for i in range(100)]
	maxValuewrite4 = np.max(valueswrite4)
	minValuewrite4 = np.min(valueswrite4)
	promediowrite4 = np.mean(valueswrite4)
	desviowrite4 = np.std(valueswrite4)

	y = []
	y.append(promediowrite2)
	y.append(promediowrite4)
	stdy = []
	stdy.append(desviowrite2)
	stdy.append(desviowrite4)
	
	ind = np.arange(1,3) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stdy,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))

	ax.set_ylabel('Ciclos de clock')
	ax.set_xticks(ind + 0.4)
	ax.set_xticklabels(('Write2','Write4'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('g')
	rects1[1].set_color('b')
	plt.show()

def write2vs4Relativo():
	filewrite2 = '1.salida.caso.write2.txt' 
	filewrite4 = '1.salida.caso.write4.txt'

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
	y = []
	y.append(minValuewrite2/minValuewrite2)
	y.append(minValuewrite4/minValuewrite2)
	stdy = []
	stdy.append(promediowrite2/minValuewrite2 - y[0])
	stdy.append(promediowrite4/minValuewrite2 - y[1])
	print y, stdy
	stds    = [(0,0), stdy]
	ind = np.arange(1,3) 
	width = .75     

	fig, ax = plt.subplots()
	rects1 = ax.bar(ind, y, width, yerr=stds,error_kw=dict(ecolor='gray', lw=1, capsize=3, capthick=1))

	ax.set_ylabel('Ciclos de clock en comparacion con ASM original')
	ax.set_xticks(ind + 0.4)
	ax.set_xticklabels(('ASM Oringinal','ASM Alternativo'))
	plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
	rects1[0].set_color('g')
	rects1[1].set_color('b')
	plt.show()		

def write2vs4ClocksPorPixel():
	filewrite2 = '1.salida.caso.write2.txt' 
	filewrite4 = '1.salida.caso.write4.txt'

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

	filewrite2_1024 = '2.salida.caso.1024.write2.txt' 
	filewrite4_1024 = '2.salida.caso.1024.write4.txt'

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

	filewrite2_2048 = '3.salida.caso.2048.write2.txt' 
	filewrite4_2048 = '3.salida.caso.2048.write4.txt'

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
	write2vs4Relativo()
	#write2vs4ClocksPorPixel()

if __name__ == "__main__":
	main()