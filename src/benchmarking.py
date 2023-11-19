import matplotlib.pyplot as plt

N_valuesc = []
timesc = []

with open('timesC.txt', 'r') as file:
    for line in file:
        
        parts = line.split(':')
        if len(parts) == 2:
            N_valuesc.append(int(parts[0])) 
            timesc.append(float(parts[1])) 

N_valuesCUDA = []
timesCUDA = []

with open('timesCUDA.txt', 'r') as file:
    for line in file:
        
        parts = line.split(':')
        if len(parts) == 2:
            N_valuesCUDA.append(int(parts[0])) 
            timesCUDA.append(float(parts[1])) 

N_valuesCUDAfull = []
timesCUDAfull = []

with open('timesCUDAfull.txt', 'r') as file:
    for line in file:
        
        parts = line.split(':')
        if len(parts) == 2:
            N_valuesCUDAfull.append(int(parts[0])) 
            timesCUDAfull.append(float(parts[1])) 




# Plot the data
plt.plot(N_valuesc[:400], timesc[:400])
plt.plot(N_valuesCUDA[:400], timesCUDA[:400])
plt.plot(N_valuesCUDAfull[:400], timesCUDAfull[:400])
plt.legend(["pure C","CUDA", "CUDA + data loading"])
plt.xlabel('Matrix Size N')
plt.ylabel('Time (seconds)')
plt.title('Matrix Multiplication pure C')
plt.grid(True)
plt.show()