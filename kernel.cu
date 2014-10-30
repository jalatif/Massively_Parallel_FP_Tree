/******************************************************************************
 *cr
 *cr         (C) Copyright 2010-2013 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

// Define your kernels in this file you may use more than one kernel if you
// need to

// INSERT KERNEL(S) HERE

#include <stdio.h>
#include <cuda.h>
#include <string.h>
#include <stdlib.h>

__device__ inline unsigned int uatomicAdd(unsigned int* address, int incr){

	int expected = *address;
	int old_val = atomicCAS((int*) address, expected, expected + incr);

	while (old_val != expected){
		expected = old_val;
		old_val = atomicCAS((int*) address, expected, expected + incr);
	}
	return old_val;
}

__global__ void histogram_kernel(unsigned int *input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins){

	__shared__ short int private_items[];

	int tx = threadIdx.x;
	int current = tx + blockDim.x * blockIdx.x;
	int location_x;

	for (int i = 0; i < ceil(num_bins / (1.0 * blockDim.x)); i++){
		location_x = tx + i * blockDim.x;
		if ( location_x < num_bins)
			private_histogram[location_x] = 0;
	}
	__syncthreads();

	if (current < num_elements && input[current] < num_bins){
		atomicAdd((unsigned int*)(&private_histogram[input[current]]), 1);
	}

	__syncthreads();

	for (int i = 0; i < ceil(num_bins / (1.0 * blockDim.x)); i++){
		location_x = tx + i * blockDim.x;
		if (location_x < num_bins)
			atomicAdd((int*)(&bins[location_x]), private_histogram[location_x]);
	}
}





/******************************************************************************
Setup and invoke your kernel(s) in this function. You may also allocate more
GPU memory if you need to
*******************************************************************************/
void histogram(unsigned int* input, unsigned int* bins, unsigned int num_elements,
        unsigned int num_bins) {

    // INSERT CODE HERE
	unsigned int block_size = 512;
    dim3 grid_dim, block_dim;

    block_dim.x = block_size; 
    block_dim.y = 1; block_dim.z = 1;
	
	grid_dim.x = ceil(num_elements / (1.0 * block_size)); 
	grid_dim.y = 1; grid_dim.z = 1;

	size_t private_hist_size = num_bins * sizeof(unsigned int);
	histogram_kernel<<<grid_dim, block_dim, private_hist_size>>>(input, bins, num_elements, num_bins);
}


/// Dynamic Shared memory
///
