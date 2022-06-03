import torch
import torch.nn as nn
import torch.nn.functional as F
from torchsummary import summary

class ConvBlock(nn.Module):
    ''' Basic Module Which Implements Conv+ReLU Two Times '''
    def __init__(self, in_channels, middle_channels, out_channels):
        super().__init__()
        conv_relu = []
        conv_relu.append(nn.Conv2d(in_channels = in_channels, out_channels = middle_channels, kernel_size = 3, padding = 1, stride = 1))
        conv_relu.append(nn.ReLU(inplace = True))
        conv_relu.append(nn.Conv2d(in_channels = middle_channels, out_channels = out_channels, kernel_size = 3, padding = 1, stride = 1))
        conv_relu.append(nn.ReLU(inplace = True))
        self.conv_ReLU = nn.Sequential(*conv_relu)
    def forward(self, x):
        out = self.conv_ReLU(x)
        return out

class UNet(nn.Module):
    '''UNet Architecture'''
    def __init__(self):
        super().__init__()
        # Down Sampling
        self.left_conv_1 = ConvBlock(in_channels = 1, middle_channels = 64, out_channels = 64)
        self.pool_1 = nn.MaxPool2d(kernel_size = 2, stride = 2)

        self.left_conv_2 = ConvBlock(in_channels = 64, middle_channels = 128, out_channels = 128)
        self.pool_2 = nn.MaxPool2d(kernel_size = 2, stride = 2)

        self.left_conv_3 = ConvBlock(in_channels = 128, middle_channels = 256, out_channels = 256)
        self.pool_3 = nn.MaxPool2d(kernel_size = 2, stride = 2)

        self.left_conv_4 = ConvBlock(in_channels = 256, middle_channels = 512, out_channels = 512)
        self.pool_4 = nn.MaxPool2d(kernel_size = 2, stride = 2)

        self.left_conv_5 = ConvBlock(in_channels = 512, middle_channels = 1024, out_channels = 1024)

        # Up Sampling
        self.deconv_1 = nn.ConvTranspose2d(in_channels = 1024, out_channels = 512, kernel_size = 3, stride = 2, padding = 1, output_padding = 1)
        self.right_conv_1 = ConvBlock(in_channels = 1024, middle_channels = 512, out_channels = 512)

        self.deconv_2 = nn.ConvTranspose2d(in_channels = 512, out_channels = 256, kernel_size = 3, padding = 1, stride = 2, output_padding = 1)
        self.right_conv_2 = ConvBlock(in_channels = 512, middle_channels = 256, out_channels = 256)

        self.deconv_3 = nn.ConvTranspose2d(in_channels = 256, out_channels = 128, kernel_size = 3, padding = 1, stride = 2 ,output_padding = 1)
        self.right_conv_3 = ConvBlock(in_channels = 256, middle_channels = 128, out_channels = 128)

        self.deconv_4 = nn.ConvTranspose2d(in_channels = 128, out_channels = 64, kernel_size = 3, stride = 2, output_padding = 1, padding = 1)
        self.right_conv_4 = ConvBlock(in_channels = 128, middle_channels = 64, out_channels = 64)

        self.right_conv_5 = nn.Conv2d(in_channels = 64, out_channels = 1, kernel_size = 1, stride = 1, padding = 0)
        self.linear_1 = nn.Linear(128 * 128, 512)
        self.linear_2 = nn.Linear(512, 5)

    def forward(self, x):
        # Encoding
        feature_1 = self.left_conv_1(x)
        feature_1_pool = self.pool_1(feature_1)
        
        feature_2 = self.left_conv_2(feature_1_pool)
        feature_2_pool = self.pool_2(feature_2)

        feature_3 = self.left_conv_3(feature_2_pool)
        feature_3_pool = self.pool_3(feature_3)

        feature_4 = self.left_conv_4(feature_3_pool)
        feature_4_pool = self.pool_4(feature_4)

        feature_5 = self.left_conv_5(feature_4_pool)

        # Decoding
        de_feature_1 = self.deconv_1(feature_5)
        # Feature Concat
        temp = torch.cat((feature_4, de_feature_1), dim = 1)
        de_feature_1_conv = self.right_conv_1(temp)

        de_feature_2 = self.deconv_2(de_feature_1_conv)
        temp = torch.cat((feature_3, de_feature_2), dim = 1)
        de_feature_2_conv = self.right_conv_2(temp)

        de_feature_3 = self.deconv_3(de_feature_2_conv)

        temp = torch.cat((feature_2, de_feature_3), dim = 1)
        de_feature_3_conv = self.right_conv_3(temp)

        de_feature_4 = self.deconv_4(de_feature_3_conv)
        temp = torch.cat((feature_1, de_feature_4), dim = 1)
        de_feature_4_conv = self.right_conv_4(temp)

        out = self.right_conv_5(de_feature_4_conv)

        # Prediction
        out = self.linear_1(out.view(out.size(0), -1))
        out = F.relu(out)
        out = self.linear_2(out)

        return out

# Test Unit
if __name__ == "__main__":
    x = torch.rand(size=(1, 1, 224, 224))
    net = UNet()
    out = net(x)
    print(out.size())