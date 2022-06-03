import os
import cv2
import numpy as np
import torch
from torch.utils.data import DataLoader, Dataset
from sklearn.model_selection import train_test_split
import torchvision.transforms as transforms

IMG_SIZE = 128
N_DIM = 5
RANDOM_SEED = 10

class ImgDataset(Dataset):
    def __init__(self, X, Y = None, transform=None):
        self.X, self.Y = X, Y
        self.Y = Y if Y is None else torch.FloatTensor(Y)
        self.transform = transform

    def __len__(self):
        return len(self.X)

    def __getitem__(self, index):
        x = self.X[index]
        x = x if self.transform is None else self.transform(x) 
        if self.Y is not None:
            y = self.Y[index]
            return x, y
        else:
            return x

def readfile(path):
    image_dir = sorted(os.listdir(path))
    x = np.zeros((len(image_dir), IMG_SIZE, IMG_SIZE), dtype = np.uint8)
    y = np.zeros((N_DIM, len(image_dir)))    

    for i, file in enumerate(image_dir):
        img = cv2.imread(os.path.join(path, file))
        x[i, :, :] = cv2.resize(img[:,:,1], (IMG_SIZE, IMG_SIZE))
        for j in np.arange(N_DIM):
            y[j, i] = file.split(".p")[0].split('_')[j + 1] 
    return x, y

def getdataloader(path = r'D:\Deep_Learning_Data_Deviated2\Deep_Learning_Data_Deviated3\No_deviation', batch_size = 16, mode = 'train'):
    train_transform = transforms.Compose([transforms.ToPILImage(), transforms.ToTensor(), ])
    test_transform = transforms.Compose([transforms.ToPILImage(), transforms.ToTensor(),])
    
    X, Y = readfile(os.path.join(path, "training")) if mode == 'train' else readfile(os.path.join(path, "testing")) 
    Y = Y.T

    if mode != 'train':
        test_set = ImgDataset(X, Y, test_transform)
        test_loader = DataLoader(test_set, batch_size = batch_size, shuffle = False, drop_last = False)
        return test_loader

    train_X, val_X, train_Y, val_Y = train_test_split(X, Y, test_size = .15, random_state = RANDOM_SEED)
    train_set = ImgDataset(train_X, train_Y, train_transform)
    val_set = ImgDataset(val_X, val_Y, test_transform)

    train_loader = DataLoader(train_set, batch_size = batch_size, shuffle = True, drop_last = True)
    val_loader = DataLoader(val_set, batch_size = batch_size, shuffle = False, drop_last = True)

    return train_loader, val_loader
