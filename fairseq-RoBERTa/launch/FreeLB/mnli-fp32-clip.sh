
function run_exp {
    GPU=${1}                     # GPU id, use, e.g., "0,1" for multiple GPUs
    TOTAL_NUM_UPDATES=${2}       # Total number of parameter updates
    WARMUP_UPDATES=${3}          # Learning rate warmup steps
    LR=${4}                      # (Maximum) learning rate
    NUM_CLASSES=${5}             # Number of classes for the task
    MAX_SENTENCES=${6}           # Max number of sentences PER GPU!
    FREQ=${7}                    # Gradient accumulation steps. Effective batch size = num_gpus * MAX_SENTENCES * FREQ
    DATA=${8}                    # Task/Dataset name
    ADV_LR=${9}                  # Step size for adversary
    ADV_STEPS=${10}              # Gradient ascent steps for adversary
    INIT_MAG=${11}               # Magnitude of initial (adversarial?) perturbation
    SEED=${12}                   # Seed for randomness
    MNORM=${13}                  # Maximum norm of adversarial perturbation

ROBERTA_PATH=pretrained/roberta.large/model.pt
exp_name=FreeLB-syncdp-${DATA}-iters${TOTAL_NUM_UPDATES}-warmup${WARMUP_UPDATES}-lr${LR}-bsize${MAX_SENTENCES}-freq${FREQ}-advlr${ADV_LR}-advstep${ADV_STEPS}-initmag${INIT_MAG}-fp32-seed${SEED}-beta0.999-mnorm${MNORM}
log_path=logs/${exp_name}.log
echo "running with GPU"${GPU}
echo ${log_path}
CUDA_VISIBLE_DEVICES=${GPU} \
    python train.py ${DATA}-bin/ \
    --restore-file $ROBERTA_PATH \
    --max-positions 512 \
    --max-sentences $MAX_SENTENCES \
    --max-tokens 4400 \
    --task sentence_prediction \
    --reset-optimizer --reset-dataloader --reset-meters \
    --required-batch-size-multiple 1 \
    --init-token 0 --separator-token 2 \
    --arch roberta_large \
    --save-interval 1 --keep-last-epochs 0 \
    --criterion sentence_prediction \
    --num-classes $NUM_CLASSES \
    --update-freq ${FREQ} \
    --dropout 0.1 --attention-dropout 0.1 \
    --weight-decay 0.1 --optimizer adam --adam-betas "(0.9, 0.999)" --adam-eps 1e-06 \
    --clip-norm 0.0 \
    --save-dir roberta-chks/${exp_name} \
    --lr-scheduler polynomial_decay --lr $LR --total-num-update $TOTAL_NUM_UPDATES --warmup-updates $WARMUP_UPDATES \
    --max-epoch 10 \
    --find-unused-parameters \
    --best-checkpoint-metric accuracy --maximize-best-checkpoint-metric \
    --rand-init-mag ${INIT_MAG} --adv-lr ${ADV_LR} --adv-steps ${ADV_STEPS} \
    --seed ${SEED} \
    --max-norm ${MNORM} \
    > ${log_path} 2>&1 &
    #--fp16 --fp16-init-scale 4 --threshold-loss-scale 1 --fp16-scale-window 128 \
}


# run_exp   GPU    TOTAL_NUM_UPDATES    WARMUP_UPDATES      LR      NUM_CLASSES MAX_SENTENCES   FREQ    DATA    ADV_LR  ADV_STEP  INIT_MAG   SEED   MNORM
#run_exp      4           123873               7432         1e-05       3            3             1       MNLI   1e-1        2    1e-2   8888      2e-1
#run_exp      0           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     2e-1   8888      2e-1
#run_exp      1           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     2e-1   1114      2e-1
#run_exp      2           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     2e-1   7456      2e-1
#run_exp      3           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     2e-1   2333      2e-1
#run_exp      4           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     2e-1   9017      2e-1
#run_exp      0           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     1e-1   8888      3e-1
#run_exp      1           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     1e-1   1114      3e-1
#run_exp      0           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     1e-1   7456      3e-1
#run_exp      1           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     1e-1   2333      3e-1
#run_exp      2           123873               7432         1e-05       3            3             1       MNLI   1e-1        2     1e-1   9017      3e-1

# run_exp      0           123873               7432         1e-05       3           32             1         MNLI    0        0       0      1000      0       
# run_exp      0           247746              14864         1e-05       3           16             1         MNLI    0        0       0      1000      0     
# run_exp      0           495492              29738         1e-05       3            8             1         MNLI    0        0       0      1000      0       
# run_exp      0           990984              59456         1e-05       3            4             1         MNLI    0        0       0      1000      0       
# run_exp      0           123873               7432         1e-05       3           32             1         MNLI   1e-1        2     1e-1   1000      3e-1
# run_exp      0           247746              14864         1e-05       3           16             1         MNLI   1e-1        2     1e-1   1000      3e-1
# run_exp      0           495492              29738         1e-05       3            8             1         MNLI   1e-1        2     1e-1   1000      3e-1
# run_exp      0           990984              59456         1e-05       3            4             1         MNLI   1e-1        2     1e-1   1000      3e-1

