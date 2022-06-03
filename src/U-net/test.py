import torch
import time
import pandas as pd
import numpy as np
from dataloader import getdataloader


USE_CUDA = torch.cuda.is_available

def test(model, batch_size):
    # Model test
    st = time.time()
    
    model.load_state_dict(torch.load("_UNet_best_state_dict.pt"))
    model = model.cuda() if USE_CUDA else model
    model.eval()

    loss_fn = torch.nn.MSELoss(reduction = 'mean')
    # Create test dataset and dataloader
    test_loader = getdataloader(batch_size = batch_size, mode = 'test')
    
    with torch.no_grad():
        cnt, loss_sum = 0, 0
        for i, (batch_X, batch_Y) in enumerate(test_loader):
            if USE_CUDA:
                batch_X, batch_Y = batch_X.cuda(), batch_Y.cuda()
            batch_pred = model(batch_X)
            loss = loss_fn(batch_Y, batch_pred)
            loss_sum += loss
            cnt += 1
            if i == 0:
                gt, pred = batch_Y, batch_pred
            else:
                gt, pred = torch.cat((gt, batch_Y), dim = 0), torch.cat((pred, batch_pred), dim = 0)
    final_loss = loss_sum / cnt
    ed = time.time()
    print("Inference Time consumption: {}s, Test_Loss: {}.".format(ed - st, final_loss))

    gt, pred = gt.cpu().numpy(), pred.cpu().numpy()
    pred[pred > 1] = 1
    pred[pred < 0] = 0
    data = np.concatenate((gt, pred), axis = 1)

    data_df = pd.DataFrame(data)
    data_df.columns = ['gt_1','gt_2','gt_3','gt_4','gt_5','pred_1','pred_2','pred_3','pred_4','pred_5']
    data_df.to_csv("res.csv")