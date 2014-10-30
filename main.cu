
#include <stdio.h>
#include <cuda.h>
#include <string.h>
#include <stdlib.h>

#define max_items_in_transaction 128
#define max_num_of_transaction 100000

int main(int argc, char**argv) {

	//File read into datastructures

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
    unsigned short int **transactions = NULL;
    unsigned short int **
    transactions = (unsigned short int **) malloc(max_num_of_transaction * sizeof(unsigned short int *));

    while ((read = getline(&line, &len, fp)) != -1){
    	// printf("%s", line);
		transactions[lines] = (unsigned short int *) malloc(max_items_in_transaction * sizeof(unsigned short int));
    	
    	count = 0;

    	ln = strtok(line, " ");
    	if (ln != NULL){
    			//unsigned short int a = (unsigned short int) strtoul(ln, NULL, 0);
    			transactions[lines][count++] = (unsigned short int) strtoul(ln, NULL, 0);
    	}
    	
    	while (ln != NULL){
    		// printf("%s ", ln);
    		ln = strtok(NULL, " ");
    		if (ln != NULL){
    			transactions[lines][count++] = (unsigned short int) strtoul(ln, NULL, 0);
    		}

    	}
    	transactions[lines][count] = NULL;
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
    printf("%d\n", lines);

    /////////////////////////////////////////////////////////////////////////////////////

    

    return 0;

}
