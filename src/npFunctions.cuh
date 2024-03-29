#pragma once

#include "npGPUArray.cuh"
#include "customKernels.cuh"
#include "npRandom.cuh"

#include <cuda_runtime.h>

#include <iostream>

namespace np {
	template<typename TP>
	ArrayGPU<TP> ones(int rows = 1, int cols = 1);

	template<typename TP>
	ArrayGPU<TP> zeros(int rows = 1, int cols = 1);

	template<typename TP>
	ArrayGPU<TP> arange(int range);

	// max(a, b). element wise maximum
	template<typename TP>
	ArrayGPU<TP> maximum(ArrayGPU<TP> &A, ArrayGPU<TP> &B);

	template<typename TP>
	ArrayGPU<TP> maximum(ArrayGPU<TP> &A, TP Scalar);

	//np.exp
	template<typename TP>
	ArrayGPU<TP> exp(ArrayGPU<TP> &A);

	// np.log
	template<typename TP>
	ArrayGPU<TP> log(ArrayGPU<TP> &A);

	// np.square
	template<typename TP>
	ArrayGPU<TP> square(ArrayGPU<TP> &A);

	// np.sqrt
	template<typename TP>
	ArrayGPU<TP> sqrt(ArrayGPU<TP> &A);

	// np.pow 
	template<typename TP>
	ArrayGPU<TP> pow(ArrayGPU<TP> &A, int pow);


	template<typename TP>
	ArrayGPU<TP> ones(int rows, int cols) {
		return ArrayGPU<TP>(rows, cols, static_cast<TP>(1));
	}

	template<typename TP>
	ArrayGPU<TP> zeros(int rows, int cols) {
		return ArrayGPU<TP>(rows, cols, static_cast<TP>(0));
	}

	template<typename TP>
	ArrayGPU<TP> arange(int range) {
		ArrayGPU<TP> ans(range);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(range, block.x));

		kernelInitMatArange<TP> << <grid, block >> > (ans.mat, range);
		cudaDeviceSynchronize();

		return ans;
	}

	template<typename TP>
	// max(a, b). element wise maximum
	ArrayGPU<TP> maximum(ArrayGPU<TP>& A, ArrayGPU<TP>& B) {
		if (A.rows == 1 || A.cols == 1) {
			// A is a scalar
			ArrayGPU<TP> res(B.rows, B.cols);

			const int BLOCK_SIZE = 128;
			dim3 block(BLOCK_SIZE);
			dim3 grid(ceil(res.size(), block.x));
			kernelMatMaximumScalar<TP><<<grid, block>>>(B.mat, A.at(0), res.mat, res.size());
			cudaDeviceSynchronize();
			return res;
		}
		else if (B.rows == 1 || B.cols == 1) {
			// B is a scalar
			ArrayGPU<TP> res(A.rows, A.cols);

			const int BLOCK_SIZE = 128;
			dim3 block(BLOCK_SIZE);
			dim3 grid(ceil(res.size(), block.x));
			kernelMatMaximumScalar<TP> << <grid, block >> > (A.mat, B.at(0), res.mat, res.size());
			cudaDeviceSynchronize();
			return res;
		}
		else if (A.rows == B.rows && A.cols == B.cols) {
			// same dimension. element wise comparison

			ArrayGPU<TP> res(A.rows, A.cols);

			const int BLOCK_SIZE = 128;
			dim3 block(BLOCK_SIZE);
			dim3 grid(ceil(res.size(), block.x));

			kernelMatMaximumMat<TP> << <grid, block >> > (A.mat, B.mat, res.mat, res.size());
			cudaDeviceSynchronize();
			return res;
		}
	}

	template<typename TP>
	ArrayGPU<TP> maximum(ArrayGPU<TP> &A, TP Scalar) {
		ArrayGPU<TP> res(A.rows, A.cols);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(res.size(), block.x));
		kernelMatMaximumScalar<TP> << <grid, block >> > (A.mat, Scalar, res.mat, res.size());
		cudaDeviceSynchronize();
		return res;
	}

	template<typename TP>
	// max(a, b). element wise maximum
	ArrayGPU<TP> minimum(ArrayGPU<TP>& A, ArrayGPU<TP>& B) {
		if (A.rows == 1 || A.cols == 1) {
			// A is a scalar
			ArrayGPU<TP> res(B.rows, B.cols);

			const int BLOCK_SIZE = 128;
			dim3 block(BLOCK_SIZE);
			dim3 grid(ceil(res.size(), block.x));
			kernelMatMinimumScalar<TP><<<grid, block>>>(B.mat, A.at(0), res.mat, res.size());
			cudaDeviceSynchronize();
			return res;
		}
		else if (B.rows == 1 || B.cols == 1) {
			// B is a scalar
			ArrayGPU<TP> res(A.rows, A.cols);

			const int BLOCK_SIZE = 128;
			dim3 block(BLOCK_SIZE);
			dim3 grid(ceil(res.size(), block.x));
			kernelMatMinimumScalar<TP> << <grid, block >> > (A.mat, B.at(0), res.mat, res.size());
			cudaDeviceSynchronize();
			return res;
		}
		else if (A.rows == B.rows && A.cols == B.cols) {
			// same dimension. element wise comparison

			ArrayGPU<TP> res(A.rows, A.cols);

			const int BLOCK_SIZE = 128;
			dim3 block(BLOCK_SIZE);
			dim3 grid(ceil(res.size(), block.x));

			kernelMatMinimumMat<TP> << <grid, block >> > (A.mat, B.mat, res.mat, res.size());
			cudaDeviceSynchronize();
			return res;
		}
	}

	template<typename TP>
	ArrayGPU<TP> minimum(ArrayGPU<TP> &A, TP Scalar) {
		ArrayGPU<TP> res(A.rows, A.cols);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(res.size(), block.x));
		kernelMatMinimumScalar<TP> << <grid, block >> > (A.mat, Scalar, res.mat, res.size());
		cudaDeviceSynchronize();
		return res;
	}

	//np.exp
	template<typename TP>
	ArrayGPU<TP> exp(ArrayGPU<TP>& A) {
		ArrayGPU<TP> res(A.rows, A.cols);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(res.size(), block.x));
		kernelExpMat<TP> << <grid, block >> > (A.mat, res.mat, res.size());
		cudaDeviceSynchronize();
		return res;
	}

	// np.log
	template<typename TP>
	ArrayGPU<TP> log(ArrayGPU<TP>& A) {
		ArrayGPU<TP> res(A.rows, A.cols);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(res.size(), block.x));
		kernelLogMat<TP> << <grid, block >> > (A.mat, res.mat, res.size());
		cudaDeviceSynchronize();
		return res;
	}

	// np.square
	template<typename TP>
	ArrayGPU<TP> square(ArrayGPU<TP> &A){
		ArrayGPU<TP> res(A.rows, A.cols);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(res.size(), block.x));
		kernelSquareMat<TP> << <grid, block >> > (A.mat, res.mat, res.size());
		cudaDeviceSynchronize();
		return res;
	}

	// np.sqrt
	template<typename TP>
	ArrayGPU<TP> sqrt(ArrayGPU<TP> &A){
		ArrayGPU<TP> res(A.rows, A.cols);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(res.size(), block.x));
		kernelSqrtMat<TP> << <grid, block >> > (A.mat, res.mat, res.size());
		cudaDeviceSynchronize();
		return res;
	}

	// np.pow 
	template<typename TP>
	ArrayGPU<TP> pow(ArrayGPU<TP> &A, int pow){
		ArrayGPU<TP> res(A.rows, A.cols);

		const int BLOCK_SIZE = 128;
		dim3 block(BLOCK_SIZE);
		dim3 grid(ceil(res.size(), block.x));
		kernelPowMat<TP> << <grid, block >> > (A.mat, pow, res.mat, res.size());
		cudaDeviceSynchronize();
		return res;
	}
}
