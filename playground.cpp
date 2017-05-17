#include <iostream>
#include <fstream>
#include <regex>

using namespace std;

int main()
{
	ifstream file("./data/enwiki-latest-abstract.xml");
	string buffer;
	regex tag("^<title>.+");
	int counter = 0;
	while(!file.eof())
	{
		getline(file, buffer);
		if (regex_search(buffer, tag))
		{
			counter += 1;
			if (counter % 10000 == 0)
			{
				cout << counter << endl;
			} 
		}
	}
	return 0;
}