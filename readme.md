# Nginx rtmp server

This is a simple nginx rtmps server

- Input output devices list: https://www.ffmpeg.org/ffmpeg-devices.html on Mac os: ffmpeg -f avfoundation -list_devices true -i “”
- Sample stream camera on mac to server: 

```
ffmpeg -f avfoundation -r 30 -i “0:0” -deinterlace -vcodec libx264 -pix_fmt yuv420p -preset medium -g 60 -b:v 2500k -acodec libmp3lame -ar 44100 -threads 6 -qscale 3 -b:a 712000 -bufsize 512k -f flv rtmp://localhost/live/tabvn
Stream from a file to server: ffmpeg -re -i video.mkv -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 -ar 44100 -f flv rtmp://localhost/live/tabvn
```