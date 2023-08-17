# bash launch/FreeLB/qqp-fp32-clip.sh
# bash launch/FreeLB/rte-fp32-clip.sh
# bash launch/FreeLB/mnli-fp32-clip.sh
# bash launch/FreeLB/qnli-fp32-clip.sh
# bash launch/FreeLB/sst-fp32-clip.sh
# bash launch/FreeLB/cola-fp32-clip.sh
# bash launch/FreeLB/mrpc-fp32-clip.sh
# bash launch/FreeLB/stsb-fp32.sh

# TASKS="QNLI QQP RTE MNLI SST-2"
# MODELS_PATH=./roberta-chks/
# DATAS_PATH=../00_data/AdvGLUE/SUB_data
# for TASK in $TASKS; do
#     echo $TASK
#     MODELS=`ls $MODELS_PATH | grep $TASK | xargs`
#     DATAS=`ls $DATAS_PATH | grep $TASK | xargs`
#     for model in $MODELS
#     do
#         for data in $DATAS
#         do
#             echo ${MODELS_PATH}/${model}/eval/${data}.log
#             mkdir -p ${MODELS_PATH}/${model}/eval
#             echo python eval_glue.py --model ${MODELS_PATH}/${model} --data_path ${DATAS_PATH}/${data} --task ${TASK}
#             python eval_glue.py --model ${MODELS_PATH}/${model} --data_path ${DATAS_PATH}/${data} --task ${TASK} > ${MODELS_PATH}/${model}/eval/${data}.log
#         done
#     done
# done


TASKS="QNLI QQP RTE MNLI SST-2"
MODELS_PATH=./roberta-chks/
DATAS_PATH=..//00_data/AdvGLUE/SUB_data
for TASK in $TASKS; do
    echo $TASK
    MODELS=`ls $MODELS_PATH | grep $TASK | xargs`
    DATAS=`ls $DATAS_PATH | grep $TASK | xargs`
    for model in $MODELS
    do
        for data in $DATAS
        do
            
            if [ -e "${MODELS_PATH}/${model}/eval/${data}.log" ]; then
                m=`echo $model |sed "s/SST-2/SST2/g"| cut -f 3,12 -d -`
                acc=`cat ${MODELS_PATH}/${model}/eval/${data}.log | grep Acc | cut -f 2 -d :`
                echo ${m},${data},${acc}
                #,${MODELS_PATH}/${model}/eval/${data}.log
            fi
        done
    done
done