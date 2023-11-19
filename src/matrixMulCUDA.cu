#include <stdio.h>
#include <cuda_runtime.h>

__global__ void matrixMulCUDA(float *C, float *A, float *B, int width) {
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int row = blockIdx.y * blockDim.y + threadIdx.y;

    if(row < width && col < width) {
        float sum = 0;
        for (int k = 0; k < width; k++) {
            sum += A[row * width + k] * B[k * width + col];
        }
        C[row * width + col] = sum;
    }
}

int main() {

    FILE *fileCUDAfull = fopen("timesCUDAfull.txt", "w");
    if (fileCUDAfull == NULL) {
        printf("Error opening file!\n");
        return 1;
    }

    FILE *fileCUDA = fopen("timesCUDA.txt", "w");
    if (fileCUDA == NULL) {
        printf("Error opening file!\n");
        return 1;
    }

    int startN = 1;
    int stepN = 1;
    int maxN = 500;

    
    int numOfIterations = (maxN / stepN);
    double timesCUDA[numOfIterations];
    double timesCUDAfull[numOfIterations];

    for(int N = startN, id =0; N < maxN; N+=stepN, ++id){
        float milliseconds = 0;
        double full_time_used = 0;
        clock_t startf, endf;

        startf = clock();
        cudaEvent_t start, stop;

        cudaEventCreate(&start);
        cudaEventCreate(&stop);

        cudaEventRecord(start);

        size_t size = N * N * sizeof(float);
        float *A, *B, *C; 
        float *d_A, *d_B, *d_C; 

        cudaMalloc((void **)&d_A, size);
        cudaMalloc((void **)&d_B, size);
        cudaMalloc((void **)&d_C, size);

        A = (float *)malloc(size);
        B = (float *)malloc(size);
        C = (float *)malloc(size);

        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                A[i * N + j] = sin(i) * cos(j); 
            }
        }

        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                B[i * N + j] = cos(i) * sin(j); 
            }
        }

        cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
        cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

        dim3 threadsPerBlock(16, 16);
        dim3 blocksPerGrid((N + threadsPerBlock.x - 1) / threadsPerBlock.x,
                          (N + threadsPerBlock.y - 1) / threadsPerBlock.y);
        matrixMulCUDA<<<blocksPerGrid, threadsPerBlock>>>(d_C, d_A, d_B, N);

        cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

        cudaEventRecord(stop);
        cudaEventSynchronize(stop);

        cudaEventElapsedTime(&milliseconds, start, stop);

        timesCUDA[id] = milliseconds/1000;
        endf = clock();
        full_time_used = ((double) (endf - startf)) / CLOCKS_PER_SEC;

        timesCUDAfull[id] = full_time_used;
        cudaEventDestroy(start);
        cudaEventDestroy(stop);

        cudaFree(d_A); cudaFree(d_B); cudaFree(d_C);
        free(A); free(B); free(C);
    } 

    for (int i = 0; i < numOfIterations; i++) {
        fprintf(fileCUDAfull, "%d: %f\n", (i + 1) * stepN, timesCUDAfull[i]);
    }

    for (int i = 0; i < numOfIterations; i++) {
        fprintf(fileCUDA, "%d: %f\n", (i + 1) * stepN, timesCUDA[i]);
    }

    fclose(fileCUDA);
    fclose(fileCUDAfull);
    

    return 0;
}
