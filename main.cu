
#include <stdio.h>
#include <cuda.h>
#include <string.h>
#include <stdlib.h>
#include "support.h"
#include "kernel.cu"

int main(int argc, char**argv) {

	//File read into datastructures

    FILE *fp = fopen("topic-0.txt", "r");
    if (fp == NULL){
    	printf("Can't read file");
    	exit(0);
    }
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    unsigned int lines = 0;
    unsigned int count = 0;
    char *ln, *nptr;
    
    unsigned int *transactions = NULL;
    unsigned int *trans_offset = NULL;
    unsigned int *flist = NULL;

    unsigned int element_id = 0;
    unsigned int check_null = 0;
    
    transactions = (unsigned int *) malloc(max_num_of_transaction * max_items_in_transaction * sizeof(unsigned int));
    trans_offset = (unsigned int *) malloc((max_num_of_transaction + 1) * sizeof(unsigned int));
    flist = (unsigned int *) malloc(max_unique_items * sizeof(unsigned int));

    trans_offset[0] = 0;

    while ((read = getline(&line, &len, fp)) != -1){
    	
    	count = 0;

    	ln = strtok(line, " ");
    	if (ln != NULL){
    			//unsigned int a = (unsigned int) strtoul(ln, NULL, 0);
    			transactions[element_id++] = (unsigned int) strtoul(ln, NULL, 0);
    			count++;
    	}
    	
    	while (ln != NULL){
    		// printf("%s ", ln);
    		ln = strtok(NULL, " ");
    		if (ln != NULL){
    			check_null = (unsigned int) strtoul(ln, &nptr, 0);
    			if (strcmp(nptr, ln) != 0){
    				transactions[element_id++] = check_null;
    				count++;
    			}
    		}

    	}

    	trans_offset[lines + 1] = trans_offset[lines] + count;

   		lines++;
    }
    fclose(fp);

    trans_offset[lines] = NULL;
    //transactions[element_id] = NULL;

    unsigned int num_items_in_transactions = element_id;
    unsigned int num_transactions = lines;

    // for (int i = 0; i < num_transactions; i++){
    // 	int item_ends = 0;
    // 	if (i == (num_transactions - 1)){
    // 		item_ends = num_items_in_transactions;
    // 	}else{
    // 		item_ends = trans_offset[i+1];
    // 	}
    // 	for (int j = trans_offset[i]; j < item_ends; j++)
    // 		printf("%hu ", transactions[j]);
    // 	printf("\n");
    // }

    printf("Number of Transactions = %d\n", lines);
  
    /////////////////////////////////////////////////////////////////////////////////////
    /////////////////////// Device Variables Initializations ///////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////

	Timer timer;
	cudaError_t cuda_ret;
	dim3 grid_dim, block_dim;

    unsigned int *d_transactions;
    unsigned int *d_trans_offsets;
    unsigned int *d_flist;
    
    // Allocate device variables ----------------------------------------------

    printf("Allocating device variables..."); fflush(stdout);
    startTime(&timer);

    cuda_ret = cudaMalloc((void**)&d_transactions, num_items_in_transactions * sizeof(unsigned int));
    if(cuda_ret != cudaSuccess) FATAL("Unable to allocate device memory");
    cuda_ret = cudaMalloc((void**)&d_trans_offsets, num_transactions * sizeof(unsigned int));
    if(cuda_ret != cudaSuccess) FATAL("Unable to allocate device memory");
   	cuda_ret = cudaMalloc((void**)&d_flist, max_unique_items * sizeof(unsigned int));
    if(cuda_ret != cudaSuccess) FATAL("Unable to allocate device memory");
	
	cuda_ret = cudaMemset(d_flist, 0, max_unique_items * sizeof(unsigned int));
    if(cuda_ret != cudaSuccess) FATAL("Unable to set device memory");

    cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    // Copy host variables to device ------------------------------------------
	
	printf("Copying data from host to device..."); fflush(stdout);
    startTime(&timer);

    cuda_ret = cudaMemcpy(d_transactions, transactions, num_items_in_transactions * sizeof(unsigned int),
        cudaMemcpyHostToDevice);
    if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to the device");

	cuda_ret = cudaMemcpy(d_trans_offsets, trans_offset, num_transactions * sizeof(unsigned int),
        cudaMemcpyHostToDevice);
    if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to the device");

    
    cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    // Launch kernel ----------------------------------------------------------
    printf("Launching kernel..."); fflush(stdout);
    startTime(&timer);

    block_dim.x = BLOCK_SIZE; 
    block_dim.y = 1; block_dim.z = 1;
    
    grid_dim.x = ceil(num_transactions / (1.0 * BLOCK_SIZE)); 
    grid_dim.y = 1; grid_dim.z = 1;  

	//size_t private_flist_size = max_unique_items * sizeof(unsigned int);
    makeFlist<<<grid_dim, block_dim>>>(d_trans_offsets, d_transactions, d_flist, num_transactions, num_items_in_transactions);
    cuda_ret = cudaDeviceSynchronize();
    if(cuda_ret != cudaSuccess) FATAL("Unable to launch/execute kernel");

    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

 	// Copy device variables from host ----------------------------------------

    printf("Copying data from device to host..."); fflush(stdout);
    startTime(&timer);

    cuda_ret = cudaMemcpy(flist, d_flist, max_unique_items * sizeof(unsigned int),
        cudaMemcpyDeviceToHost);
	if(cuda_ret != cudaSuccess) FATAL("Unable to copy memory to host");

    cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    //#if TEST_MODE
    printf("\nResult:\n");
    for(unsigned int i = 0; i < max_unique_items; ++i) {
        printf("Item %u: %u frequency\n", i, flist[i]);
    }
    //#endif

    // Free memory ------------------------------------------------------------

    free(trans_offset);
    free(transactions);

    cudaFree(d_trans_offsets);
    cudaFree(d_transactions);
    
    return 0;

}
