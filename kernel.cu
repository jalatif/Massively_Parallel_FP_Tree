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

#define max_unique_items 16384

#define BLOCK_SIZE 1024

__global__ void makeFlist(unsigned int *d_trans_offset, unsigned short int *d_transactions , unsigned int num_transactions, unsigned int num_items_in_transactions){

	__shared__ unsigned short int private_items[max_unique_items];

	int tx = threadIdx.x + blockDim.x * blockIdx.x;
	
	int item_ends = 0;
	
	if (tx == (num_transactions - 1)){
		item_ends = num_items_in_transactions;
	}else{
		item_ends = d_trans_offset[tx + 1];
	}

	for(int i = d_trans_offset[tx]; i < item_ends; i++){
		atomicAdd((int*)&private_items[d_transactions[i]], 1);
	}
}
