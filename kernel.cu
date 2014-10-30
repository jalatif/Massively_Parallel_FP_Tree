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

#define max_items_in_transaction 128
#define max_num_of_transaction 1000000

#define max_unique_items 8192

#define BLOCK_SIZE 512

__global__ void makeFlist(unsigned int *d_trans_offset, unsigned int *d_transactions , unsigned int num_transactions, unsigned int num_items_in_transactions){

	__shared__ unsigned int private_items[max_unique_items];

	int tx = threadIdx.x + blockDim.x * blockIdx.x;
	int location_x;

	for (int i = 0; i < ceil(max_unique_items / (1.0 * blockDim.x)); i++){
		location_x = tx + i * blockDim.x;
		if ( location_x < max_unique_items)
			private_items[location_x] = 0;
	}
	__syncthreads();

	
	int item_ends = 0;
	
	if (tx == (num_transactions - 1)){
		item_ends = num_items_in_transactions;
	}else{
		item_ends = d_trans_offset[tx + 1];
	}
	//int j = 0;
	for(int i = d_trans_offset[tx]; i < item_ends; i++){
		if (d_transactions[i] >=0 && d_transactions[i] < max_unique_items)
			atomicAdd(&private_items[0], 1);
		//j = d_transactions[i];
	}
}
