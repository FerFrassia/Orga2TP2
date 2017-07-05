import csv
import sys
from os import listdir
from os.path import isfile, join
import matplotlib.pyplot as plt
from math import sqrt

def get_min(csvfile):
	minimo = 9999999999999999
	spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
	for row in spamreader:
		if int(row[0]) < minimo:
			minimo = int(row[0])
	return minimo

def get_max(csvfile):
	maximo = 0
	spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
	for row in spamreader:
		if int(row[0]) > maximo:
			maximo = int(row[0])
	return maximo

def main():
	onlyfiles = [join(sys.argv[1], f) for f in sorted(listdir(sys.argv[1])) if isfile(join(sys.argv[1], f))]
	for filepath in onlyfiles:
		with open( filepath, 'rb') as csvfile:
			if csvfile.name.split('.')[-1] == 'txt':
				print 'Leyendo' + filepath + '...'
				minimo = float(get_min(csvfile))
				print 'Minimo: ' + str(minimo)
				anchoCuad = int(csvfile.name.split('.')[-2]) * int(csvfile.name.split('.')[-2])
				print 'Clocks por pixel en imagen de ' + str(sqrt(anchoCuad)) + ' son ' + str(minimo/anchoCuad) + '\n\n'

				#plot(filepath)


def plot(filepath):
	file = open(filepath, "r")

	values = [int(i) for i in file.readlines()]
	indexes = [i for i in range(100)]
	maxValue = max(values) * 1.05
	minValue = min(values) * 0.8

	plt.plot(indexes, values, 'ro')
	plt.axis([0, 100, minValue, maxValue])
	plt.title(file.name.split('.')[-2])
	plt.ylabel('Clocks por imagen de 512x512')
	plt.xlabel('Corridas')
	plt.show()


if __name__ == "__main__":
	main()