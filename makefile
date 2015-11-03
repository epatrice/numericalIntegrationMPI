all: integrationSample.cpp
	mpiCC -o integrationSample integrationSample.cpp

clean:
	$(RM) integrationSample
