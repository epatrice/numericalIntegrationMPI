Readme


Programmed on Nov 1, 2015
Author: Eduardo Patrice


1 Source File: integrationSample.cpp

PURPOSE:
This is a MPI C++ parallel program that performs numerical integrations.
Different functions are included.

TO COMPILE:
To compile this program, please issue the following command:
	make
or:
	mpiCC -o integrationSample integrationSample.cpp

FILES INCLUDED
Files included as header:

iostream.h for I/O functions like cout
mpi.h      for MPI functions
cmath      for using the sin(), cos() and tan() functions
cstdlib    for general functions


HOW TO RUN THE PROGRAM
Here is a sample run: Integrate cosine from 0 to pi with 1048576 intervals.

	mpirun -np 8 ./integrationSample 1048576 0 3.141592 0

The output is then:
	With n == 1048576 trapezoids, our estimate
	of the integral from 0 to 3.141592 is 2
	Number of processors used = 8

Which gives a pretty good approximation (real value = 2).

Here is another sample run: Integrate 1/x from 1 to 2 using 1048576 intervals.

	mpirun -np 8 ./integrationSample 1048576 1 2 3
	
The output is then:
	With n == 1048576 trapezoids, our estimate
	of the integral from 1 to 2 is 0.693147
	Number of processors used = 8


Which again gives a good approximation (TI 89 calculator gives me ln(2) = 0.693147181).

In general, to execute my program, use this command:

	mpirun -np numproc ./integrationSample n a b flag

Where,
- numproc is the number of processors
- n is the number of intervals that we want to divide from [a,b]
- a is the start point for integration
- b is the end point of the integration
- flag is used to choose which function to integrate

VALUES OF FLAGS
-------------------
| flag | Meaning  |
|   0  | cos(x)   |
|   1  | sin(x)   |
|   2  | tan(x)   |
|   3  | 1/x      |
| else | cos(x)   |
-------------------



HOW IT WORKS:
The program first get all the inputs from the command line,
then the program calculate all the values to be used:
	h = (b-a)/n
	local_n = n/p
	local_a = a+my_rank*(b-a)/p;
	
local_b is not used because having the values of local_n and local_a, 
I can sum everything up from local_a until my loop counter reaches local_n.

As a result, every of my for loop execute local_n+1 = n/p+1 times.

Every process have its own value of integral. 
What is left is just sum all the integral up to get the total.

To achieve this, I used MPI reduce:

	MPI_Reduce(&integral, &total, 1, MPI_DOUBLE, MPI_SUM, 0 , MPI_COMM_WORLD);	
	
At last, the process with rank = 0 will output the total to the screen.

	
