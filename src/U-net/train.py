import torch
import random
import time
import numpy as np
import torch.nn as nn
import torch.utils.data as tud
from dataloader import getdataloader

random_seed = 10
random.seed(random_seed)
np.random.seed(random_seed)
torch.manual_seed(random_seed)
torch.cuda.manual_seed_all(random_seed)

torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False

USE_CUDA = torch.cuda.is_available

def initialize(layer):
    # Xavier_uniform will be applied to conv1d and dense layer
    if isinstance(layer,nn.Conv2d) or isinstance(layer, nn.Linear):    
        torch.nn.init.xavier_uniform_(layer.weight.data)
        if layer.bias is not None:
            torch.nn.init.constant_(layer.bias.data, val = 0.0)

def train(model, epochs, batch_size, train_patience = 3):
    model = model.cuda() if USE_CUDA else model
    model.apply(initialize)
    train_loader, valid_loader = getdataloader(batch_size = batch_size)
    patience, best_loss = 0, None

    loss_fn = torch.nn.MSELoss(reduction = 'mean')
    optimizer = torch.optim.Adam(model.parameters(), lr = 1e-4)

    for epoch in range(epochs):
        # Earlystopping
        if(patience == train_patience):
            print("val_loss did not improve after {} Epochs, thus Earlystopping is calling".format(train_patience))
            break   

        # train the model
        model.train()
        st = time.time()     
        for i, (batch_X, batch_Y) in enumerate(train_loader):
            if USE_CUDA:
                batch_X, batch_Y = batch_X.cuda(), batch_Y.cuda()
            
            batch_pred = model(batch_X)
            loss = loss_fn(batch_Y, batch_pred)

            model.zero_grad()    
            loss.backward()
            optimizer.step()
        ed = time.time()

        # Evaluate the model    
        model.eval()
        with torch.no_grad():
            cnt, loss_sum = 0, 0
            for i, (batch_X, batch_Y) in enumerate(valid_loader):
                if USE_CUDA:
                    batch_X, batch_Y = batch_X.cuda(), batch_Y.cuda()
            
                batch_pred = model(batch_X)
                loss = loss_fn(batch_Y, batch_pred)
                loss_sum += loss
                cnt += 1
        
        final_loss = loss_sum / cnt

        # Save best only
        if best_loss is None or final_loss < best_loss:
            best_loss, patience = final_loss, 0
            net_state_dict = model.state_dict()
            path_state_dict = "./_UNet_best_state_dict.pt"
            torch.save(net_state_dict, path_state_dict)
        else:
            patience = patience + 1 

        print("Epoch: {}, Valid_Loss: {}, Time consumption: {}s.".format(epoch, final_loss, ed - st))
