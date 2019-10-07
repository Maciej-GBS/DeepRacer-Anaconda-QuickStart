#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main() {
	// For security reasons do not use environment PATH
	char* base = "/bin/rm -R ";
	char* repo = "/home/gbs/Documents/HashCode/DeepRacer/deepracer/";
	char* paths[2];
	char block[256];
	int v;
	paths[0] = "robo/job/*";
	paths[1] = "robo/container/*";
	// Set user to root when executing bash commands
	v = setuid(0);
	for (int i = 0; i < 2; i++) {
		strcpy(block, base);
		strcat(block, repo);
		strcat(block, paths[i]);
		printf("Cleaning: %s\n", block);
		v = v + system(block);
	}
	return v;
}
