function psnr=Cal_psnr(u,Ima)
mse=mean((u(:)-Ima(:)).^2);
psnr=10*log10(1.0/(mse+1e-15));