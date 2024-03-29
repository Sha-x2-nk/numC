#pragma once

#include <cuda_runtime.h>
#include <curand.h>
#include <curand_kernel.h>
#include <cmath>

#include <iostream>
#include <type_traits> // for std::is_same

// curand kernels

// for uniform distribution
template<typename TP>
__global__ void kernelInitializeRandomUnif(TP* arr, const int size, const unsigned long long seed);

// for uniform distribution range = [lo, hi]
template<typename TP>
__global__ void kernelInitializeRandomUnif(TP* arr, int size, int lo, int hi, unsigned long long seed);

// for normal distribution
template<typename TP>
__global__ void kernelInitializeRandomNorm(TP* arr, int size, unsigned long long seed);

// 1 x 1 grid to print matrices
template<typename TP>
__global__ void kernelPrintMat(TP* in, int M, int N);

// kernel to transpose an array.
template<typename TP, int TILE_DIM, int BLOCK_ROWS>
// TILE_WIDTH = 32. 1 block copies 32 x 32 elements. 
__global__ void kernelTransposeInMem(TP* idata, TP* odata, int M, int N);

// kernel to initialise all values of array to val.
template<typename TP>
__global__ void kernelInitMatBroadcast(TP* in, TP Val, int size);

//kernel to initialised arange array -> 0 to n - 1, array size N
template<typename TP>
__global__ void kernelInitMatArange(TP* in, int size);

// kernel to get values at a range of indexes.
template<typename TP>
__global__ void kernelGetMatValues(TP* in, TP* out, int* idxs, int size);

// kernel to get values at a range of indexes.
template<typename TP>
__global__ void kernelGetMatValues(TP* in, int rdin, TP* out, int* rows, int* cols, int size);

// kernel to set values at a range of indexes.
template<typename TP>
__global__ void kernelSetMatValues(TP* in, int rdin, TP* val, int* rows, int* cols, int size);

// kernel to set values at a range of indexes.
template<typename TP>
__global__ void kernelSetMatValues(TP* in, TP* val, int* idxs, int size);

//ARITHMATIC FUNCTIONs

// addition functions

//add corrosponding elements of 2 matrices 
// C = A + B
template<typename TP>
__global__ void kernelMatAddMat(TP* A, TP* B, TP* C, int size);

//add matrix and a scalar.
// C = A + Scal (broadcasting)
//add scalar to all values of the matrix
template<typename TP>
__global__ void kernelMatAddScalar(TP* A, TP Scal, TP* C, int size);

//add matrix  and vector, mat.rows = vec.dim 
//C = A + V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatAddVecAlongRows(TP* A, TP* V, TP* C, int size, int N);

//add matrix  and vector, mat.cols = vec.dim 
//C = A + V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatAddVecAlongCols(TP* A, TP* V, TP* C, int size, int N);

// subtraction functions

//subtract corrosponding elements of 2 matrices 
// C = A - B
template<typename TP>
__global__ void kernelMatSubMat(TP* A, TP* B, TP* C, int size);

//subtract matrix and a scalar.
// C = A - Scal (broadcasting)
//subtract scalar from all values of the matrix
template<typename TP>
__global__ void kernelMatSubScalar(TP* A, TP Scal, TP* C, int size);

//sub matrix  and vector, mat.rows = vec.dim 
//C = A - V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatSubVecAlongRows(TP* A, TP* V, TP* C, int size, int N);

//sub matrix and vector, mat.cols = vec.dim 
//C = A - V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatSubVecAlongCols(TP* A, TP* V, TP* C, int size, int N);

// multiplication functions

//mul corrosponding elements of 2 matrices 
// C = A * B
template<typename TP>
__global__ void kernelMatMulMat(TP* A, TP* B, TP* C, int size);

//mul matrix and a scalar.
// C = A * Scal (broadcasting)
//mul scalar to all values of the matrix
template<typename TP>
__global__ void kernelMatMulScalar(TP* A, TP Scal, TP* C, int size);

//mul matrix  and vector, mat.rows = vec.dim 
//C = A * V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatMulVecAlongRows(TP* A, TP* V, TP* C, int size, int N);

//mul matrix  and vector, mat.cols = vec.dim 
//C = A * V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatMulVecAlongCols(TP* A, TP* V, TP* C, int size, int N);

// division functions

//div corrosponding elements of 2 matrices 
// C = A / B
template<typename TP>
__global__ void kernelMatDivMat(TP* A, TP* B, TP* C, int size);

//div matrix and a scalar.
// C = A / Scal (broadcasting)
//div scalar to all values of the matrix
template<typename TP>
__global__ void kernelMatDivScalar(TP* A, TP Scal, TP* C, int size);

//div matrix  and vector, mat.rows = vec.dim 
//C = A / V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatDivVecAlongRows(TP* A, TP* V, TP* C, int size, int N);

//div matrix  and vector, mat.cols = vec.dim 
//C = A / V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatDivVecAlongCols(TP* A, TP* V, TP* C, int size, int N);

// compare 2 matrix ( element wise ) and put max value in result matrix.
//A = MxN
//B = MxN
//Ci = max(Ai, Bi). (elementwise)
template<typename TP>
__global__ void kernelMatMaximumMat(TP* A, TP *B, TP* C, int size);

// compare a matrix and a scalar and put max of them in result matrix.
//A = MxN
//B = scalar
//Ci = max(Ai, B). (elementwise)
template<typename TP>
__global__ void kernelMatMaximumScalar(TP* A, TP B, TP* C, int size);

// comparison operators

// compare 2 matrix. tell if former greater.
//A = MxN
//B = scalar
//Ci = Ai > Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanMat(TP* A, TP *B, TP* C, int size);

// compare a matrix and scalar tell if former greater.
//A = MxN
//B = scalar
//Ci = Ai > B. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanScalar(TP* A, TP B, TP* C, int size);

// compare 2 matrix. tell if former smaller.
//A = MxN
//B = scalar
//Ci = Ai < Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanMat(TP* A, TP* B, TP* C, int size);

// compare a matrix and scalar tell if former smaller.
//A = MxN
//B = scalar
//Ci = Ai < B. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanScalar(TP* A, TP B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai >= Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanEqMat(TP* A, TP* B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai >= B. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanEqScalar(TP* A, TP B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai <= Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanEqMat(TP* A, TP* B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai <= B. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanEqScalar(TP* A, TP B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai == Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsEqMat(TP* A, TP* B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai == B. (elementwise)
template<typename TP>
__global__ void kernelMatIsEqScalar(TP* A, TP B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai != Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsNotEqMat(TP* A, TP* B, TP* C, int size);

//A = MxN
//B = scalar
//Ci = Ai != B. (elementwise)
template<typename TP>
__global__ void kernelMatIsNotEqScalar(TP* A, TP B, TP* C, int size);

// np.exp
// A = MxN
// C = MxN
//Ci = exp(Ai)
template<typename TP>
__global__ void kernelExpMat(TP* A, TP* C, int size);

// np.log
// A = MxN
// C = MxN
//Ci = exp(Ai)
template<typename TP>
__global__ void kernelLogMat(TP* A, TP* C, int size);

// np.square
// A = MxN
// C = MxN
//Ci = square(Ai)
template<typename TP>
__global__ void kernelSquareMat(TP* A, TP* C, int size);

// np.sqrt
// A = MxN
// C = MxN
//Ci = square(Ai)
template<typename TP>
__global__ void kernelSqrtMat(TP* A, TP* C, int size);

// np.pow
// A = MxN
// C = MxN
//Ci = square(Ai)
template<typename TP>
__global__ void kernelPowMat(TP* A, int pow, TP* C, int size);

// REDUCTION

// np.sum(A)
// A = MxN
// np.sum(A)
template< typename TP >
__device__ void kernelWarpReduceSum(volatile TP* s_A, int tid);

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceSum(TP* A, TP* output, int size);

template< typename TP >
__device__ void kernelWarpReduceMax(volatile TP* s_A, int tid);

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceMax(TP* A, TP* output, int size);

// min
template< typename TP >
__device__ void kernelWarpReduceMin(volatile TP* s_A, int tid);

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceMin(TP* A, TP* output, int size);

template< typename TP >
__device__ void kernelWarpReduceArgMax(volatile TP* s_A, volatile int* s_Idx, int tid);

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMax(TP* A, TP* outputMax, int *outputIdx, int size);

// second reduction k time p -> idx serial nhi h, to ek idx ka bhi array dena hoga
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMax(TP* A, int *A_idx, TP* outputMax, int* outputIdx, int size);

template< typename TP >
__device__ void kernelWarpReduceArgMin(volatile TP* s_A, volatile int* s_Idx, int tid);

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMin(TP* A, TP* outputMax, int* outputIdx, int size);

// second reduction k time p -> idx serial nhi h, to ek idx ka bhi array dena hoga
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMin(TP* A, int *A_idx, TP* outputMax, int* outputIdx, int size);


// ########## FUNCTION DEFINITIONS


// for uniform distribution
template<typename TP>
__global__ void kernelInitializeRandomUnif(TP* arr, int size, unsigned long long seed) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        curandState state;
        curand_init(seed, idx, 0, &state);  // Initialize curand state for each thread
        arr[idx] = curand_uniform(&state);  // Generate a random value
    }
}

// for uniform distribution
template<typename TP>
__global__ void kernelInitializeRandomUnif(TP* arr, int size, int lo, int hi, unsigned long long seed) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        curandState state;
        curand_init(seed, idx, 0, &state);  // Initialize curand state for each thread
        arr[idx] = (curand_uniform(&state) * (hi - lo) + lo);  // Generate a random value
    }
}

// for normal distribution
template<typename TP>
__global__ void kernelInitializeRandomNorm(TP* arr, int size, unsigned long long seed) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        curandState state;
        curand_init(seed, idx, 0, &state);  // Initialize curand state for each thread
        arr[idx] = curand_normal(&state);  // Generate a random value
    }
}

// 1 x 1 grid to print matrices
template<typename TP>
__global__ void kernelPrintMat(TP* in, int M, int N) {
	// 1, 1 grid. only to print matrix
	for (int r = 0; r < M; ++r) {
		for (int c = 0; c < N; ++c) {
			if (std::is_same<TP, int>::value) {
				printf("%d ", in[r * N + c]);
			}
			else if (std::is_same<TP, float>::value) {
				printf("%f ", in[r * N + c]);
			}
			else if (std::is_same<TP, double>::value) {
				printf("%lf ", in[r * N + c]);
			}
			else if (std::is_same<TP, char>::value) {
				printf("%c ", in[r * N + c]);
			}
			else {
				// Handle other types here
				printf("Unsupported type");
			}
		}
		printf("\n");
	}
}

// kernel to transpose an array.
template<typename TP, int TILE_DIM, int BLOCK_ROWS>
// TILE_WIDTH = 32. 32 x 32 copy krega ek matrix
__global__ void kernelTransposeInMem(TP* idata, TP* odata, int M, int N) {
	__shared__ TP tile[TILE_DIM][TILE_DIM + 1];
	int x = blockIdx.x * TILE_DIM + threadIdx.x;
	int y = blockIdx.y * TILE_DIM + threadIdx.y;

	for (int j = 0; j < TILE_DIM; j += BLOCK_ROWS) {
		if (y + j < M && x < N) {
			tile[threadIdx.y + j][threadIdx.x] = idata[(y + j) * N + x];
		}

	}

	__syncthreads();

	x = blockIdx.y * TILE_DIM + threadIdx.x;  // transpose block offset
	y = blockIdx.x * TILE_DIM + threadIdx.y;

	for (int j = 0; j < TILE_DIM; j += BLOCK_ROWS) {
		if (y + j < N && x < M) {
			odata[(y + j) * M + x] = tile[threadIdx.x][threadIdx.y + j];
		}
	}

}

// kernel to initialise all values of array to val.
template<typename TP>
__global__ void kernelInitMatBroadcast(TP* in, TP Val, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		in[idx] = Val;
	}
}

//kernel to initialised arange array -> 0 to n - 1, array size N
template<typename TP>
__global__ void kernelInitMatArange(TP* in, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		in[idx] = idx;
	}
}

// kernel to get values at a range of indexes.
template<typename TP>
__global__ void kernelGetMatValues(TP* in, TP* out, int* idxs, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		out[idx] = in[idxs[idx]];
	}
}

// kernel to get values at a range of indexes.
template<typename TP>
__global__ void kernelGetMatValues(TP* in, int rdin, TP* out, int* rows, int* cols, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		out[idx] = in[rows[idx] * rdin + cols[idx]];
	}
}

// kernel to set values at a range of indexes.
template<typename TP>
__global__ void kernelSetMatValues(TP* in, int rdin, TP* val, int* rows, int* cols, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx < size) {
		in[rows[idx] * rdin + cols[idx]] = val[idx];
	}
}

// kernel to set values at a range of indexes.
template<typename TP>
__global__ void kernelSetMatValues(TP* in, TP* val, int* idxs, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx < size) {
		in[idxs[idx]] = val[idx];
	}
}


//ARITHMATIC FUNCTIONs

// addition functions

//add corrosponding elements of 2 matrices 
// C = A + B
template<typename TP>
__global__ void kernelMatAddMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] + B[idx];
	}
}

//add matrix and a scalar.
// C = A + Scal (broadcasting)
//add scalar to all values of the matrix
template<typename TP>
__global__ void kernelMatAddScalar(TP* A, TP Scal, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] + Scal;
	}
}

//add matrix  and vector, mat.rows = vec.dim 
//C = A + V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatAddVecAlongRows(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int r = idx / N;
	//int c = idx % N; 

	if (idx < size) {
		C[idx] = A[idx] + V[r];
	}
}

//add matrix  and vector, mat.cols = vec.dim 
//C = A + V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatAddVecAlongCols(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	//int r = idx / N;
	int c = idx % N;

	if (idx < size) {
		C[idx] = A[idx] + V[c];
	}
}

// subtraction functions

//subtract corrosponding elements of 2 matrices 
// C = A - B
template<typename TP>
__global__ void kernelMatSubMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] - B[idx];
	}
}

//subtract matrix and a scalar.
// C = A - Scal (broadcasting)
//subtract scalar from all values of the matrix
template<typename TP>
__global__ void kernelMatSubScalar(TP* A, TP Scal, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] - Scal;
	}
}

//sub matrix  and vector, mat.rows = vec.dim 
//C = A - V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatSubVecAlongRows(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int r = idx / N;
	//int c = idx % N; 

	if (idx < size) {
		C[idx] = A[idx] - V[r];
	}
}

//sub matrix and vector, mat.cols = vec.dim 
//C = A - V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatSubVecAlongCols(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	//int r = idx / N;
	int c = idx % N;

	if (idx < size) {
		C[idx] = A[idx] - V[c];
	}
}


// multiplication functions

//mul corrosponding elements of 2 matrices 
// C = A * B
template<typename TP>
__global__ void kernelMatMulMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] * B[idx];
	}
}

//mul matrix and a scalar.
// C = A * Scal (broadcasting)
//mul scalar to all values of the matrix
template<typename TP>
__global__ void kernelMatMulScalar(TP* A, TP Scal, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] * Scal;
	}
}

//mul matrix  and vector, mat.rows = vec.dim 
//C = A * V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatMulVecAlongRows(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int r = idx / N;
	//int c = idx % N; 

	if (idx < size) {
		C[idx] = A[idx] * V[r];
	}
}

//mul matrix  and vector, mat.cols = vec.dim 
//C = A * V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatMulVecAlongCols(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	//int r = idx / N;
	int c = idx % N;

	if (idx < size) {
		C[idx] = A[idx] * V[c];
	}
}

// division functions

//div corrosponding elements of 2 matrices 
// C = A / B
template<typename TP>
__global__ void kernelMatDivMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] / B[idx];
	}
}


//div matrix and a scalar.
// C = A / Scal (broadcasting)
//div scalar to all values of the matrix
template<typename TP>
__global__ void kernelMatDivScalar(TP* A, TP Scal, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] / Scal;
	}
}

//div matrix  and vector, mat.rows = vec.dim 
//C = A / V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatDivVecAlongRows(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int r = idx / N;
	//int c = idx % N; 

	if (idx < size) {
		C[idx] = A[idx] / V[r];
	}
}

//div matrix  and vector, mat.cols = vec.dim 
//C = A / V (broadcasting)
// shapeA = M x N matrix
template<typename TP>
__global__ void kernelMatDivVecAlongCols(TP* A, TP* V, TP* C, int size, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	//int r = idx / N;
	int c = idx % N;

	if (idx < size) {
		C[idx] = A[idx] / V[c];
	}
}


//A = MxN
//B = MxN
//Ci = max(Ai, Bi). (elementwise)
template<typename TP>
__global__ void kernelMatMaximumMat(TP* A, TP *B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] > B[idx])
			C[idx] = A[idx];
		else
			C[idx] = B[idx];
	}
}

//A = MxN
//B = scalar
//Ci = max(Ai, B). (elementwise)
template<typename TP>
__global__ void kernelMatMaximumScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] > B)
			C[idx] = A[idx];
		else
			C[idx] = B;
	}
}

//A = MxN
//B = MxN
//Ci = min(Ai, Bi). (elementwise)
template<typename TP>
__global__ void kernelMatMinimumMat(TP* A, TP *B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] < B[idx])
			C[idx] = A[idx];
		else
			C[idx] = B[idx];
	}
}

//A = MxN
//B = scalar
//Ci = max(Ai, B). (elementwise)
template<typename TP>
__global__ void kernelMatMinimumScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] < B)
			C[idx] = A[idx];
		else
			C[idx] = B;
	}
}

// comparison operators

//A = MxN
//B = scalar
//Ci = Ai > Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanMat(TP* A, TP *B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] > B[idx])
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai > B. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] > B)
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}


//A = MxN
//B = scalar
//Ci = Ai < Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] < B[idx])
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai < B. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] < B)
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai >= Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanEqMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] >= B[idx])
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai >= B. (elementwise)
template<typename TP>
__global__ void kernelMatIsGreaterThanEqScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] >= B)
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}


//A = MxN
//B = scalar
//Ci = Ai <= Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanEqMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] <= B[idx])
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai <= B. (elementwise)
template<typename TP>
__global__ void kernelMatIsLessThanEqScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] <= B)
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}


//A = MxN
//B = scalar
//Ci = Ai == Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsEqMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] == B[idx])
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai == B. (elementwise)
template<typename TP>
__global__ void kernelMatIsEqScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] == B)
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai != Bi. (elementwise)
template<typename TP>
__global__ void kernelMatIsNotEqMat(TP* A, TP* B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] != B[idx])
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

//A = MxN
//B = scalar
//Ci = Ai != B. (elementwise)
template<typename TP>
__global__ void kernelMatIsNotEqScalar(TP* A, TP B, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		if (A[idx] != B)
			C[idx] = 1;
		else
			C[idx] = 0;
	}
}

// np.exp
// A = MxN
// C = MxN
//Ci = exp(Ai)
template<typename TP>
__global__ void kernelExpMat(TP* A, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = expf(A[idx]);
	}
}

// np.log
// A = MxN
// C = MxN
//Ci = exp(Ai)
template<typename TP>
__global__ void kernelLogMat(TP* A, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = logf(A[idx]);
	}
}


// np.square
// A = MxN
// C = MxN
//Ci = square(Ai)
template<typename TP>
__global__ void kernelSquareMat(TP* A, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = A[idx] * A[idx];
	}
}


// np.sqrt
// A = MxN
// C = MxN
//Ci = square(Ai)
template<typename TP>
__global__ void kernelSqrtMat(TP* A, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] =  sqrt( A[idx] );
	}
}

// np.pow
// A = MxN
// C = MxN
//Ci = square(Ai)
template<typename TP>
__global__ void kernelPowMat(TP* A, int pow, TP* C, int size) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < size) {
		C[idx] = powf(A[idx], static_cast<float>(pow));
	}
}

// REDUCTION

// np.sum(A)
// A = MxN
// np.sum(A)
template< typename TP >
__device__ void kernelWarpReduceSum(volatile TP* s_A, int tid) { // warp reduce for kernel 6
	s_A[tid] += s_A[tid + 32];
	s_A[tid] += s_A[tid + 16];
	s_A[tid] += s_A[tid + 8];
	s_A[tid] += s_A[tid + 4];
	s_A[tid] += s_A[tid + 2];
	s_A[tid] += s_A[tid + 1];
}

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceSum(TP* A, TP* output, int size) {
	const int bx = blockIdx.x;
	const int tx = threadIdx.x;
	int idx = bx * BLOCK_SIZE * 2 + tx;
	const int gridSize = BLOCK_SIZE * 2 * gridDim.x;
	__shared__ TP s_A[BLOCK_SIZE];

	s_A[tx] = 0;

	// assume 1 hi grid launch kr rha h tu
	while (idx < size) {
		s_A[tx] += ( A[idx] + ((idx + BLOCK_SIZE < size) ? A[idx + BLOCK_SIZE] : 0) );
		idx += gridSize;
	}
	__syncthreads();

	if (BLOCK_SIZE > 511) {
		if (tx < 256) {
			s_A[tx] += s_A[tx + 256];
		}
		__syncthreads();
	}

	if (BLOCK_SIZE > 255) {
		if (tx < 128) {
			s_A[tx] += s_A[tx + 128];
		}
		__syncthreads();
	}
	if (BLOCK_SIZE > 127) {
		if (tx < 64) {
			s_A[tx] += s_A[tx + 64];
		}
		__syncthreads();
	}

	if (tx < 32) kernelWarpReduceSum<TP>(s_A, tx);

	if (tx == 0) {
		 output[bx] = s_A[0];
	}
}

template< typename TP >
__device__ void kernelWarpReduceMax(volatile TP* s_A, int tid) { // warp reduce for kernel 6
	s_A[tid] = max(s_A[tid], s_A[tid + 32]);
	s_A[tid] = max(s_A[tid], s_A[tid + 16]);
	s_A[tid] = max(s_A[tid], s_A[tid + 8]);
	s_A[tid] = max(s_A[tid], s_A[tid + 4]);
	s_A[tid] = max(s_A[tid], s_A[tid + 2]);
	s_A[tid] = max(s_A[tid], s_A[tid + 1]);
}

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceMax(TP* A, TP* output, int size) {
	const int bx = blockIdx.x;
	const int tx = threadIdx.x;
	int idx = bx * BLOCK_SIZE * 2 + tx;
	const int gridSize = BLOCK_SIZE * 2 * gridDim.x;
	__shared__ TP s_A[BLOCK_SIZE];

	s_A[tx] = INT_MIN;

	// assume 1 hi grid launch kr rha h tu
	while (idx < size) {
		s_A[tx] = max(s_A[tx], A[idx]);
		if(idx + BLOCK_SIZE < size)
			s_A[tx] = max(s_A[tx], A[idx + BLOCK_SIZE]);

		idx += gridSize;
	}
	__syncthreads();

	if (BLOCK_SIZE > 511) {
		if (tx < 256) {
			s_A[tx] = max(s_A[tx], s_A[tx + 256]);
		}
		__syncthreads();
	}

	if (BLOCK_SIZE > 255) {
		if (tx < 128) {
			s_A[tx] = max(s_A[tx], s_A[tx + 128]);
		}
		__syncthreads();
	}
	if (BLOCK_SIZE > 127) {
		if (tx < 64) {
			s_A[tx] = max(s_A[tx], s_A[tx + 64]);
		}
		__syncthreads();
	}

	if (tx < 32) kernelWarpReduceMax<TP>(s_A, tx);

	if (tx == 0) {
		 output[bx] = s_A[0];
	}
}

// min
template< typename TP >
__device__ void kernelWarpReduceMin(volatile TP* s_A, int tid) { // warp reduce for kernel 6
	s_A[tid] = min(s_A[tid], s_A[tid + 32]);
	s_A[tid] = min(s_A[tid], s_A[tid + 16]);
	s_A[tid] = min(s_A[tid], s_A[tid + 8]);
	s_A[tid] = min(s_A[tid], s_A[tid + 4]);
	s_A[tid] = min(s_A[tid], s_A[tid + 2]);
	s_A[tid] = min(s_A[tid], s_A[tid + 1]);
}

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceMin(TP* A, TP* output, int size) {
	const int bx = blockIdx.x;
	const int tx = threadIdx.x;
	int idx = bx * BLOCK_SIZE * 2 + tx;
	const int gridSize = BLOCK_SIZE * 2 * gridDim.x;
	__shared__ TP s_A[BLOCK_SIZE];

	s_A[tx] = INT_MAX;

	// assume 1 hi grid launch kr rha h tu
	while (idx < size) {
		s_A[tx] = min(s_A[tx], A[idx]);
		if (idx + BLOCK_SIZE < size)
			s_A[tx] = min(s_A[tx], A[idx + BLOCK_SIZE]);

		idx += gridSize;
	}
	__syncthreads();

	if (BLOCK_SIZE > 511) {
		if (tx < 256) {
			s_A[tx] = min(s_A[tx], s_A[tx + 256]);
		}
		__syncthreads();
	}

	if (BLOCK_SIZE > 255) {
		if (tx < 128) {
			s_A[tx] = min(s_A[tx], s_A[tx + 128]);
		}
		__syncthreads();
	}
	if (BLOCK_SIZE > 127) {
		if (tx < 64) {
			s_A[tx] = min(s_A[tx], s_A[tx + 64]);
		}
		__syncthreads();
	}

	if (tx < 32) kernelWarpReduceMin<TP>(s_A, tx);

	if (tx == 0) {
		 output[bx] = s_A[0];
	}
}


template< typename TP >
__device__ void kernelWarpReduceArgMax(volatile TP* s_A, volatile int* s_Idx, int tid) { // warp reduce for kernel 6
	if (s_A[tid] < s_A[tid + 32]) {
		s_A[tid] = s_A[tid + 32];
		s_Idx[tid] = s_Idx[tid + 32];
	}
	if (s_A[tid] < s_A[tid + 16]) {
		s_A[tid] = s_A[tid + 16];
		s_Idx[tid] = s_Idx[tid + 16];
	}
	if (s_A[tid] < s_A[tid + 16]) {
		s_A[tid] = s_A[tid + 16];
		s_Idx[tid] = s_Idx[tid + 16];
	}
	if (s_A[tid] < s_A[tid + 8]) {
		s_A[tid] = s_A[tid + 8];
		s_Idx[tid] = s_Idx[tid + 8];
	}
	if (s_A[tid] < s_A[tid + 4]) {
		s_A[tid] = s_A[tid + 4];
		s_Idx[tid] = s_Idx[tid + 4];
	}
	if (s_A[tid] < s_A[tid + 2]) {
		s_A[tid] = s_A[tid + 2];
		s_Idx[tid] = s_Idx[tid + 2];
	}
	if (s_A[tid] < s_A[tid + 1]) {
		s_A[tid] = s_A[tid + 1];
		s_Idx[tid] = s_Idx[tid + 1];
	}
}

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMax(TP* A, TP* outputMax, int *outputIdx, int size) {
	const int bx = blockIdx.x;
	const int tx = threadIdx.x;
	int idx = bx * BLOCK_SIZE * 2 + tx;
	const int gridSize = BLOCK_SIZE * 2 * gridDim.x;
	__shared__ TP s_A[BLOCK_SIZE];
	__shared__ int s_Idx[BLOCK_SIZE];

	s_A[tx] = INT_MIN;
	s_A[tx] = -1;

	// assume 1 hi grid launch kr rha h tu
	while (idx < size) {
		if (s_A[tx] < A[idx]) {
			s_A[tx] = A[idx];
			s_Idx[tx] = idx;
		} 
		if (idx + BLOCK_SIZE < size) {
			if (s_A[tx] < A[idx + BLOCK_SIZE]) {
				s_A[tx] = A[idx + BLOCK_SIZE];
				s_Idx[tx] = idx + BLOCK_SIZE;
			}
		}

		idx += gridSize;
	}
	__syncthreads();

	if (BLOCK_SIZE > 511) {
		if (tx < 256) {
			if (s_A[tx] < s_A[idx + 256]) {
				s_A[tx] = s_A[idx + 256];
				s_Idx[tx] = idx + 256;
			}
		}
		__syncthreads();
	}

	if (BLOCK_SIZE > 255) {
		if (tx < 128) {
			if (s_A[tx] < s_A[idx + 128]) {
				s_A[tx] = s_A[idx + 128];
				s_Idx[tx] = idx + 128;
			}
		}
		__syncthreads();
	}
	if (BLOCK_SIZE > 127) {
		if (tx < 64) {
			if (s_A[tx] < s_A[idx + 64]) {
				s_A[tx] = s_A[idx + 64];
				s_Idx[tx] = idx + 64;
			}
		}
		__syncthreads();
	}

	if (tx < 32) kernelWarpReduceArgMax<TP>(s_A, s_Idx, tx);

	if (tx == 0) {
		outputMax[bx] = s_A[0];
		outputIdx[bx] = s_Idx[0];
	}
}

// second reduction k time p -> idx serial nhi h, to ek idx ka bhi array dena hoga
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMax(TP* A, int *A_idx, TP* outputMax, int* outputIdx, int size) {
	const int bx = blockIdx.x;
	const int tx = threadIdx.x;
	int idx = bx * BLOCK_SIZE * 2 + tx;
	const int gridSize = BLOCK_SIZE * 2 * gridDim.x;
	__shared__ TP s_A[BLOCK_SIZE];
	__shared__ int s_Idx[BLOCK_SIZE];

	s_A[tx] = INT_MIN;
	s_A[tx] = -1;

	// assume 1 hi grid launch kr rha h tu
	while (idx < size) {
		if (s_A[tx] < A[idx]) {
			s_A[tx] = A[idx];
			s_Idx[tx] = A_idx[idx];
		}
		if (idx + BLOCK_SIZE < size) {
			if (s_A[tx] < A[idx + BLOCK_SIZE]) {
				s_A[tx] = A[idx + BLOCK_SIZE];
				s_Idx[tx] = A_idx[idx + BLOCK_SIZE];
			}
		}

		idx += gridSize;
	}
	__syncthreads();

	if (BLOCK_SIZE > 511) {
		if (tx < 256) {
			if (s_A[tx] < s_A[idx + 256]) {
				s_A[tx] = s_A[idx + 256];
				s_Idx[tx] = idx + 256;
			}
		}
		__syncthreads();
	}

	if (BLOCK_SIZE > 255) {
		if (tx < 128) {
			if (s_A[tx] < s_A[idx + 128]) {
				s_A[tx] = s_A[idx + 128];
				s_Idx[tx] = idx + 128;
			}
		}
		__syncthreads();
	}
	if (BLOCK_SIZE > 127) {
		if (tx < 64) {
			if (s_A[tx] < s_A[idx + 64]) {
				s_A[tx] = s_A[idx + 64];
				s_Idx[tx] = idx + 64;
			}
		}
		__syncthreads();
	}

	if (tx < 32) kernelWarpReduceArgMax<TP>(s_A, s_Idx, tx);

	if (tx == 0) {
		outputMax[bx] = s_A[0];
		outputIdx[bx] = s_Idx[0];
	}
}


template< typename TP >
__device__ void kernelWarpReduceArgMin(volatile TP* s_A, volatile int* s_Idx, int tid) { // warp reduce for kernel 6
	if (s_A[tid] > s_A[tid + 32]) {
		s_A[tid] = s_A[tid + 32];
		s_Idx[tid] = s_Idx[tid + 32];
	}
	if (s_A[tid] > s_A[tid + 16]) {
		s_A[tid] = s_A[tid + 16];
		s_Idx[tid] = s_Idx[tid + 16];
	}
	if (s_A[tid] > s_A[tid + 16]) {
		s_A[tid] = s_A[tid + 16];
		s_Idx[tid] = s_Idx[tid + 16];
	}
	if (s_A[tid] > s_A[tid + 8]) {
		s_A[tid] = s_A[tid + 8];
		s_Idx[tid] = s_Idx[tid + 8];
	}
	if (s_A[tid] > s_A[tid + 4]) {
		s_A[tid] = s_A[tid + 4];
		s_Idx[tid] = s_Idx[tid + 4];
	}
	if (s_A[tid] > s_A[tid + 2]) {
		s_A[tid] = s_A[tid + 2];
		s_Idx[tid] = s_Idx[tid + 2];
	}
	if (s_A[tid] > s_A[tid + 1]) {
		s_A[tid] = s_A[tid + 1];
		s_Idx[tid] = s_Idx[tid + 1];
	}
}

// warp unroll
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMin(TP* A, TP* outputMax, int* outputIdx, int size) {
	const int bx = blockIdx.x;
	const int tx = threadIdx.x;
	int idx = bx * BLOCK_SIZE * 2 + tx;
	const int gridSize = BLOCK_SIZE * 2 * gridDim.x;
	__shared__ TP s_A[BLOCK_SIZE];
	__shared__ int s_Idx[BLOCK_SIZE];

	s_A[tx] = INT_MAX;
	s_A[tx] = -1;

	// assume 1 hi grid launch kr rha h tu
	while (idx < size) {
		if (s_A[tx] > A[idx]) {
			s_A[tx] = A[idx];
			s_Idx[tx] = idx;
		}
		if (idx + BLOCK_SIZE < size) {
			if (s_A[tx] > A[idx + BLOCK_SIZE]) {
				s_A[tx] = A[idx + BLOCK_SIZE];
				s_Idx[tx] = idx + BLOCK_SIZE;
			}
		}

		idx += gridSize;
	}
	__syncthreads();

	if (BLOCK_SIZE > 511) {
		if (tx < 256) {
			if (s_A[tx] > s_A[idx + 256]) {
				s_A[tx] = s_A[idx + 256];
				s_Idx[tx] = idx + 256;
			}
		}
		__syncthreads();
	}

	if (BLOCK_SIZE > 255) {
		if (tx < 128) {
			if (s_A[tx] > s_A[idx + 128]) {
				s_A[tx] = s_A[idx + 128];
				s_Idx[tx] = idx + 128;
			}
		}
		__syncthreads();
	}
	if (BLOCK_SIZE > 127) {
		if (tx < 64) {
			if (s_A[tx] > s_A[idx + 64]) {
				s_A[tx] = s_A[idx + 64];
				s_Idx[tx] = idx + 64;
			}
		}
		__syncthreads();
	}

	if (tx < 32) kernelWarpReduceArgMin<TP>(s_A, s_Idx, tx);

	if (tx == 0) {
		outputMax[bx] = s_A[0];
		outputIdx[bx] = s_Idx[0];
	}
}

// second reduction k time p -> idx serial nhi h, to ek idx ka bhi array dena hoga
template<typename TP, int BLOCK_SIZE>
__global__ void kernelReduceArgMin(TP* A, int *A_idx, TP* outputMax, int* outputIdx, int size) {
	const int bx = blockIdx.x;
	const int tx = threadIdx.x;
	int idx = bx * BLOCK_SIZE * 2 + tx;
	const int gridSize = BLOCK_SIZE * 2 * gridDim.x;
	__shared__ TP s_A[BLOCK_SIZE];
	__shared__ int s_Idx[BLOCK_SIZE];

	s_A[tx] = INT_MAX;
	s_A[tx] = -1;

	// assume 1 hi grid launch kr rha h tu
	while (idx < size) {
		if (s_A[tx] > A[idx]) {
			s_A[tx] = A[idx];
			s_Idx[tx] = A_idx[idx];
		}
		if (idx + BLOCK_SIZE < size) {
			if (s_A[tx] > A[idx + BLOCK_SIZE]) {
				s_A[tx] = A[idx + BLOCK_SIZE];
				s_Idx[tx] = A_idx[idx + BLOCK_SIZE];
			}
		}

		idx += gridSize;
	}
	__syncthreads();

	if (BLOCK_SIZE > 511) {
		if (tx < 256) {
			if (s_A[tx] > s_A[idx + 256]) {
				s_A[tx] = s_A[idx + 256];
				s_Idx[tx] = idx + 256;
			}
		}
		__syncthreads();
	}

	if (BLOCK_SIZE > 255) {
		if (tx < 128) {
			if (s_A[tx] > s_A[idx + 128]) {
				s_A[tx] = s_A[idx + 128];
				s_Idx[tx] = idx + 128;
			}
		}
		__syncthreads();
	}
	if (BLOCK_SIZE > 127) {
		if (tx < 64) {
			if (s_A[tx] > s_A[idx + 64]) {
				s_A[tx] = s_A[idx + 64];
				s_Idx[tx] = idx + 64;
			}
		}
		__syncthreads();
	}

	if (tx < 32) kernelWarpReduceArgMin<TP>(s_A, s_Idx, tx);

	if (tx == 0) {
		outputMax[bx] = s_A[0];
		outputIdx[bx] = s_Idx[0];
	}
}
