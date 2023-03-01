import sys

START_FILE= sys.argv[1]
SPLIT_NUMBER= int(sys.argv[2])
number_of_sdfs = SPLIT_NUMBER
i=0
j=0
f2=open(START_FILE+'_'+str(j)+'.sdf','w')
for line in open(START_FILE+'.sdf'):
	f2.write(line)
	if line[:4] == "$$$$":
		i+=1
	if i > number_of_sdfs:
		number_of_sdfs += SPLIT_NUMBER 
		f2.close()
		j+=1
		f2=open(START_FILE+'_'+str(j)+'.sdf','w')
print(i)
