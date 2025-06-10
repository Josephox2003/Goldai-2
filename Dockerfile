FROM ubuntu:20.04

# تثبيت المتطلبات الأساسية
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wine32 xvfb wget curl python3 python3-pip x11vnc fluxbox && \
    rm -rf /var/lib/apt/lists/*

# إعداد بيئة العمل
WORKDIR /app

# نسخ ملفات المشروع
COPY . /app

# تثبيت بايثون والحزم المطلوبة
RUN pip3 install -r requirements.txt

# إعداد Wine وتشغيل MetaTrader 4
RUN wine mt4setup.exe /S

# نسخ ملف إعداد Wine وتعديلاته إذا لزم الأمر
COPY user.reg /root/.wine/user.reg

# تعيين متغير بيئة لعرض X11 الافتراضي
ENV DISPLAY=:99

# تشغيل Xvfb و Fluxbox و MetaTrader 4 و VNC تلقائياً
CMD bash -c "Xvfb :99 -screen 0 1024x768x16 & fluxbox & x11vnc -forever -nopw -display :99 & wine terminal.exe & python3 bot.py"
