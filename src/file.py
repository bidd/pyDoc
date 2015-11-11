from tree import Tree
import numpy

'''pydoc
	#summary
	Splits a matrix in 4 equal submatrices

	#params
	M	numpy.matryx	"Original matrix"
	n	integer	"Dimension of the matrix"

	#description
	This function takes a matrix and then.
	gives back.
	whatever it wants#

	#example
	n = 4;
	M = np.zeros( n);
	split_matrix( M, n);#

	#example
	n = 8;
	M 0 np.ones( n);
	split_matrix( M, n);#

'''
def split_matrix(M,n):
	MM0= M[0:n/2, 0:n/2]							#First half rows and columns
	MM1= M[0:n/2, n/2:n] 							#First half rows and last half columns
	MM2= M[n/2:n, 0:n/2]							#Last half rows and first half columns
	MM3= M[n/2:n, n/2:n]							#Last half rows and columns
	return (MM0, MM1, MM2, MM3)
