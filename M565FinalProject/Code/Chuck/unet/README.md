# M565 Final Project: U-net

To apply the U-net model, you can use either of the `unet_gpu.py` or `unet.py`, where the latter does not have GPU support.

To use the GPU version of U-net, you need to have a CUDA compatible GPU and install CuDNN in your environment.

While running U-net on CPU alone is doable, computation with less than 50 cores can be extremely slow.

