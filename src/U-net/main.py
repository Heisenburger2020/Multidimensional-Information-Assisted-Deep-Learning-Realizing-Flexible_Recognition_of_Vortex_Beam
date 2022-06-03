import torch
from UNet import UNet
from train import train
from test import test

N_EPOCHS = 30
BATCH_SIZE = 16

model = UNet()
train(model, N_EPOCHS, BATCH_SIZE)
test(model, BATCH_SIZE)