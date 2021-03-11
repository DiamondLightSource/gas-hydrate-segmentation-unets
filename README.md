# Gas Hydrate Segmentation Using U-nets. Code Repository.

This code repository supports the article manuscript entitled 'U-Net Segmentation of XCT Images of Methane-Bearing Sand'
Authored by F. J. Alvarez-Borges, O. N. F. King, B. N. Madhusudhan, M. Basham and S. I. Ahmed.
March 2021

Copyright 2021 Diamond Light Source Ltd.
Licensed under the Apache License, Version 2.0

Funders:
Natural Environment Research Council (UK) grant No. NE/K00008X/1

## Description

### 2d and 3d U-net training and prediction scripts 

These can be found in the `unet_methods` directory. 

#### 2d methods

For 2d U-net training and prediction, settings are specified by editing the YAML files in `unet_2d/settings`. Paths for image data (HDF5 format), labels(HDF5 format) and input models are given via the command line.

##### For 2d U-net training

```shell
python train_2d_unet.py path/to/image/data.h5 path/to/corresponding/segmentation/labels.h5
```

A model will be trained and saved to your working directory

##### For 2d U-net prediction

```shell
python predict_2d_unet.py path/to/model_file.zip path/to/data_for_prediction.h5
```

A directory of segmented volumes will be saved to your working directory.

#### 3d methods

For 3d U-net training and prediction, settings are specified by editing the YAML files in `unet_3d/settings`. Paths for image data(HDF5 format), labels(HDF5 format) and input models are also given in the YAML files.

The 3d methods utilise the [Torchio](https://github.com/fepegar/torchio) library for data sampling and augmentation:
Pérez-García, Fernando, Rachel Sparks, and Sebastien Ourselin. ‘TorchIO: A Python Library for Efficient Loading, Preprocessing, Augmentation and Patch-Based Sampling of Medical Images in Deep Learning’. ArXiv:2003.04696 [Cs, Eess, Stat], 9 March 2020. http://arxiv.org/abs/2003.04696.

And the 3d U-net utilises the [pytorch-3dunet](https://github.com/wolny/pytorch-3dunet) library:
Wolny, Adrian, Lorenzo Cerrone, Athul Vijayan, Rachele Tofanelli, Amaya Vilches Barro, Marion Louveaux, Christian Wenzl, et al. ‘Accurate and Versatile 3D Segmentation of Plant Tissues at Cellular Resolution’. Edited by Christian S Hardtke, Dominique C Bergmann, Dominique C Bergmann, and Moritz Graeff. ELife 9 (29 July 2020): e57613. https://doi.org/10.7554/eLife.57613.


##### For 3d U-net training

```shell
python train_3d_unet.py 
```

A model will be trained and saved to the directory where your input data resides.

##### For 3d U-net prediction

```shell
python predict_3d_unet.py
```

A segmented volume will be saved to the directory where your input data resides.

#### Installation

In order to run the scripts locally you will need an NVIDIA GPU, ideally with at least 8GB of memory and that supports CUDA 10 or greater. We recommend creating an [Anaconda](https://www.anaconda.com/products/individual#Downloads) environment using the `unet_environment.yaml` file found in `unet_methods`.

```shell
conda env create -n unet_env -f unet_methods/unet_environment.yaml
```

Once the environment is installed you can activate it

```shell
conda activate unet_env
```
You should now be able to run the U-net training and prediction by calling the relevant scripts using Python. 

### Data preparation and Rootpainter training data scripts

These can be found in the `matlab_scripts` directory.

MATLAB code was created using MATLAB 2020b.