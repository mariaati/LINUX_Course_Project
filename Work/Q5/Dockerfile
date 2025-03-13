FROM python:3.12

RUN apt-get update && apt-get install -y \
    libcups2-dev \
    libdbus-1-dev \
    dbus \
    pkg-config \
    libgirepository1.0-dev \
    gir1.2-gtk-3.0 \
    python3-gi \
    python3-gi-cairo \
    gobject-introspection \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["python", "/app/plant_plots.py"]

