#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h> 

void multiplyMatrices(int n, double *A, double *B, double *result) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            result[i * n + j] = 0;
            for (int k = 0; k < n; k++) {
                result[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}


int main() {

  

    FILE *fileC = fopen("timesC.txt", "w");
    if (fileC == NULL) {
        printf("Error opening file!\n");
        return 1;
    }

    int startN = 1;
    int stepN = 1;
    int maxN = 500;

    
    int numOfIterations = (maxN / stepN);
    double timesC[numOfIterations];

    for(int N = startN, id =0; N < maxN; N+=stepN, ++id){
    
      double A[N * N], B[N * N], result[N * N];

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

      clock_t start, end;
      double cpu_time_used;

      start = clock();
      multiplyMatrices(N, A, B, result);
      end = clock();

      cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

      timesC[id] = cpu_time_used;
    }

    for (int i = 0; i < numOfIterations; i++) {
        fprintf(fileC, "%d: %f\n", (i + 1) * stepN, timesC[i]);
    }

    fclose(fileC);

    return 0;
}
