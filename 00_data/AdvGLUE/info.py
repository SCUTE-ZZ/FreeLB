import json
with open('dev_ann.json', 'r') as f:
	x = json.load(f)

u={}
v={}
w={}
n=0
for i in x:
	print(i,len(x[i]))
	n+=len(x[i])
	for j in x[i]:
		if j["data_construction"] == "word": 
			if (j["method"] not in u):
				u[j["method"]]=0
			u[j["method"]]+=1
		elif j["data_construction"] == "sentence":
			if (j["method"] not in v):
				v[j["method"]]=0
			v[j["method"]]+=1
		else:
			if (j["method"] not in w):
				w[j["method"]]=0
			w[j["method"]]+=1
		
print(u)
print(v)
print(w)
print("=======")
print(n)