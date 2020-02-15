int MultiPixelSearch(unsigned int * scan0,int startX,int startY,int width,int height,int stride,unsigned int argb,int *ref_x,int *ref_y){
	unsigned int * p = scan0;
	int a = (argb >> 24) & 255;
	int r = (argb >> 16) & 255;
	int g = (argb >> 8) & 255;
	int b = argb & 255;
	int x = startX;
	int y = startY;
    for (; y < height; y++)
    {
        for (; x < width; x++)
        {
			unsigned int * data = p+((x*4)+(y*stride))/4;
			int bitmapA = (*data >> 24) & 255;
			int bitmapR = (*data >> 16) & 255;
			int bitmapG = (*data >> 8) & 255;
			int bitmapB = *data & 255;
			if(a == bitmapA &&
			r == bitmapR &&
			g == bitmapG &&
			b == bitmapB){
					*ref_x = x;
					*ref_y = y;
				return 1;
			}
        }
		x = 0;
    }
	return 0;
}