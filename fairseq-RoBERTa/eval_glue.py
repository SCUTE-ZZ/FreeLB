from fairseq.models.roberta import RobertaModel
from tqdm import tqdm
import json
import argparse
# 创建ArgumentParser对象
parser = argparse.ArgumentParser()

# 添加参数
parser.add_argument("--model", help="model path")
parser.add_argument("--task", help="task")
parser.add_argument("--data_path", help="data path")


# 解析命令行参数
args = parser.parse_args()

# /home/zzding/10_AdvGLUE/00_data/AdvGLUE/sub_data

# checkpoints="/home/zzding/22_FREELB/FreeLB/fairseq-RoBERTa/roberta-chks/FreeLB-syncdp-MNLI-iters247746-warmup14864-lr1e-05-bsize16-freq1-advlr0-advstep0-initmag0-fp32-seed1000-beta0.999-mnorm0"
# data_path='glue_data/MNLI/dev.tsv'

TASK = args.task
checkpoints = args.model
data_path = args.data_path
data_name_or_path = TASK+"-bin" 

roberta = RobertaModel.from_pretrained(
    checkpoints,
    checkpoint_file='checkpoint_best.pt',
    data_name_or_path=data_name_or_path
)

label_fn = lambda label: roberta.task.label_dictionary.string(
    [label + roberta.task.target_dictionary.nspecial]
)
ncorrect, nsamples = 0, 0
roberta.cuda()
roberta.eval()
with open(data_path) as f:
    datas = json.load(f)

for data in tqdm(datas):
    for index, line in enumerate(data):
        if(TASK == 'SST-2'):
            sent1 = data["sentence"]
            target = data["label"]
            tokens = roberta.encode(sent1)
        elif(TASK == 'QQP'):
            sent1 = data["question1"]
            sent2 = data["question2"]
            target = data["label"]
            tokens = roberta.encode(sent1, sent2)
        elif(TASK=='RTE'):
            rte_label=["entailment", "not_entailment"]
            sent1 = data["sentence1"]
            sent2 = data["sentence2"]
            target = rte_label[data["label"]]
            tokens = roberta.encode(sent1, sent2)
        elif(TASK == 'QNLI' ):
            qnli_label=["entailment", "not_entailment"]
            sent1 = data["question"]
            sent2 = data["sentence"]
            target = qnli_label[data["label"]]
            tokens = roberta.encode(sent1, sent2)
        elif(TASK == 'MNLI'):
            mnli_label=["entailment","neutral","contradiction"]
            sent1 = data["premise"]
            sent2 = data["hypothesis"]
            target = mnli_label[data["label"]]
            tokens = roberta.encode(sent1, sent2)

        prediction = roberta.predict('sentence_classification_head', tokens).argmax().item()
        prediction_label = label_fn(prediction)
        ncorrect += int(prediction_label == str(target))
        nsamples += 1
print('| Accuracy: ', float(ncorrect)/float(nsamples))
print('| : ', float(ncorrect), float(nsamples))