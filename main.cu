
#include <stdio.h>
#include <cuda.h>
#include <string.h>
#include <stdlib.h>

#define n_items_in_transaction 128
#define max_items_in_transaction 100000

int main(int argc, char**argv) {

    //cudaError_t cuda_ret;

    FILE *fp = fopen("/home/manshu/UIUC/CS 412 - Data Mining/data-assign3/data-assign3/topic-0.txt", "r");
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    if (fp == NULL){
    	printf("Can't read file");
    	exit(0);
    }
    int lines = 0;
    int count = 0;
    char *ln;
    unsigned short int *trans = NULL;
    unsigned short int **transactions = NULL;
    transactions = (unsigned short int **) malloc(max_items_in_transaction * sizeof(unsigned short int *));

    while ((read = getline(&line, &len, fp)) != -1){
    	// printf("%s", line);
		trans = (unsigned short int *) malloc(n_items_in_transaction * sizeof(unsigned short int));
    	
    	count = 0;

    	ln = strtok(line, " ");
    	if (ln != NULL){
    			//unsigned short int a = (unsigned short int) strtoul(ln, NULL, 0);
    			trans[count++] = (unsigned short int) strtoul(ln, NULL, 0);
    	}
    	
    	while (ln != NULL){
    		// printf("%s ", ln);
    		ln = strtok(NULL, " ");
    		if (ln != NULL){
    			trans[count++] = (unsigned short int) strtoul(ln, NULL, 0);
    		}

    	}
    	trans[count] = NULL;

    	if (trans == NULL)
    	transactions[lines] = trans;
    	int j = 0;
    	unsigned short int *temp = transactions[lines];
   		while(temp != NULL && temp[j] != NULL){
   			printf("%hu, ", temp[j]);
   			j++;
   		}
   		printf("\n");
   		lines++;
    }
    fclose(fp);
    transactions[lines] = NULL;

    for(int i = 0; i < lines; i++){
    	int j = 0;
    	unsigned short int *temp = transactions[i];
   		while(temp != NULL && temp[j] != NULL){
   			printf("%x, ", temp[j]);
   			j++;
   		}
   		//printf("\n");
    }

    printf("%d", lines);
    int j = 0;
    unsigned short int *temp = transactions[0];
   		while(temp != NULL && temp[j] != NULL){
   			printf("%x, ", temp[j]);
   			j++;
   	}
    // float* A_h = (float*) malloc( sizeof(float)*n );
    // for (unsigned int i=0; i < n; i++) { A_h[i] = (rand()%100)/100.00; }

    // float* B_h = (float*) malloc( sizeof(float)*n );
    // for (unsigned int i=0; i < n; i++) { B_h[i] = (rand()%100)/100.00; }

    // float* C_h = (float*) malloc( sizeof(float)*n );

    // printf("    Vector size = %u\n", n);

    // Allocate device variables ----------------------------------------------

    // printf("Allocating device variables...\n"); fflush(stdout);

    // float *A_d, *B_d, *C_d;
    // int size = n * sizeof(float);

    // cudaError_t status;
    // status = cudaMalloc((void **) &A_d, size);
    // if (status != cudaSuccess){
    // 	printf("%s in %s at line %d\n", cudaGetErrorString(status), __FILE__, __LINE__);
    // 	exit(EXIT_FAILURE);
    // }
    // status = cudaMalloc((void **) &B_d, size);
    // if (status != cudaSuccess){
    // 	printf("%s in %s at line %d\n", cudaGetErrorString(status), __FILE__, __LINE__);
    // 	exit(EXIT_FAILURE);
    // }
    // status = cudaMalloc((void **) &C_d, size);
    // if (status != cudaSuccess){
    // 	printf("%s in %s at line %d\n", cudaGetErrorString(status), __FILE__, __LINE__);
    // 	exit(EXIT_FAILURE);
    // }

    // cudaDeviceSynchronize();

    // Copy host variables to device ------------------------------------------

    printf("Copying data from host to device..."); fflush(stdout);
    

    //INSERT CODE HERE

 //    cudaMemcpy(A_d, A_h, size, cudaMemcpyHostToDevice);
	// cudaMemcpy(B_d, B_h, size, cudaMemcpyHostToDevice);

 //    cudaDeviceSynchronize();
    

    // Launch kernel ----------------------------------------------------------

    printf("Launching kernel..."); fflush(stdout);

    //INSERT CODE HERE

    // dim3 DimGrid((n-1)/256 + 1, 1, 1);
    // dim3 DimBlock(256, 1, 1);

    //vecAddKernel<<<DimGrid, DimBlock>>>(A_d, B_d, C_d, n);



 //    cuda_ret = cudaDeviceSynchronize();
	// if(cuda_ret != cudaSuccess) {
 //        printf("Unable to launch kernel");
 //        exit(EXIT_FAILURE);
 //    }

    // Copy device variables from host ----------------------------------------

    printf("Copying data from device to host..."); fflush(stdout);
    

    //INSERT CODE HERE

    // cudaMemcpy(C_h, C_d, size, cudaMemcpyDeviceToHost);

    // cudaDeviceSynchronize();

    // Verify correctness -----------------------------------------------------

    // printf("Verifying results..."); fflush(stdout);

    // Free memory ------------------------------------------------------------

    // free(A_h);
    // free(B_h);
    // free(C_h);

    //INSERT CODE HERE

    // cudaFree(A_d);
    // cudaFree(B_d);
    // cudaFree(C_d);


    return 0;

}
