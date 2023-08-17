import json
import copy

with open('dev_ann.json', 'r') as f:
	x = json.load(f)

res={}

for task_name in x:
    for info in x[task_name]:
        origin = {}
        adv = {}
        for i in info:
            if(i == "data_construction" or i == "method" or i=="idx"):
                continue
            if(i.split("_")[0] != "original" and "original_"+i not in info):
                origin[i] = info[i]
                adv[i] = info[i]
            if(i.split("_")[0] != "original" and "original_"+i in info):
                adv[i] = info[i]
            if(i.split("_")[0] == "original"):
                origin[i.split("_")[1]] = info[i]

        key0_ori = task_name+"_"+"ori"+"_"+"all"+"_"+"all"
        # key1_ori = task_name+"_"+"ori"+"_"+str(info["data_construction"])+"_"+str(info["method"])

        key0_adv = task_name+"_"+"adv"+"_"+"all"+"_"+"all"
        key1_adv = task_name+"_"+"adv"+"_"+str(info["data_construction"])+"_"+str(info["method"])
        
        if(info['data_construction'] != 'human'):
            if(key0_ori not in res):
                res[key0_ori] = []
            res[key0_ori].append(origin)

            # if(key1_ori not in res):
            #     res[key1_ori] = []
            # res[key1_ori].append(origin)

            if(key0_adv not in res):
                res[key0_adv] = []
            res[key0_adv].append(adv)

        if(key1_adv not in res):
            res[key1_adv] = []            
        res[key1_adv].append(adv)

for key in res:
    with open("sub_data/"+key+".json", 'w') as f:
        json.dump(res[key], f, indent=4)